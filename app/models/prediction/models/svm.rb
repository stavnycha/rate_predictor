#
# Support vector maching, regression type
#
class Prediction
  module Models
    class Svm
      attr_reader :prediction_count

      LAG = 5
      EPS = 0.0001
      C = 50000
      NU = 0.2
      GAMMA = 0.0001

      def initialize(time_series, prediction_count)
        @time_series = time_series
        @prediction_count = prediction_count
      end

      def predicted
        prediction_count.times.map do |i|
          x_data = (time_series.size - lag).times.map do |i|
            lag.times.to_a.map do |j|
              time_series[i + j]
            end.to_example
          end

          y_data = time_series[lag..-1]

          problem = Libsvm::Problem.new
          problem.set_examples(y_data, x_data)

          model = Libsvm::Model.train(problem, parameter)

          predicted = model.predict(time_series[-lag..-1].to_example)
          time_series.push(predicted)
          [i + 1, predicted / fractional_coef]
        end
      end

      private

      def parameter
        @parameter ||= begin
          param = Libsvm::SvmParameter.new
          param.cache_size = 1 # in megabytes
          param.eps = EPS
          param.c = C
          # regression type
          param.svm_type = Libsvm::SvmType::NU_SVR
          param.nu = NU
          # [:LINEAR, :POLY, :RBF, :SIGMOID, :PRECOMPUTED]
          #
          # RBF has proven in many studies to be best pick
          # for financial forecast
          #
          param.kernel_type = Libsvm::KernelType::RBF
          param.gamma = GAMMA
          param
        end
      end

      def time_series
        @tuned_time_serier ||= @time_series.map do |item|
          item * fractional_coef
        end
      end

      # moving window
      def lag
        [ LAG, prediction_count.size - 1 ].min
      end

      # some experimental tuning
      def fractional_coef
        @fractional_coef ||= begin
          int = @time_series.first.to_i
          power = int == 0 ? 1 : 1 - int.to_s.size
          1000 * 10**power
        end
      end
    end
  end
end
