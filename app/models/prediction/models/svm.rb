class Prediction
  module Models
    class Svm
      attr_reader :time_series, :prediction_count

      LAG = 5

      def initialize(time_series, prediction_count)
        @time_series = time_series.map do |item|
          item * fractional_coef
        end
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
          param.eps = 1
          param.c = 100000
          # [:LINEAR, :POLY, :RBF, :SIGMOID, :PRECOMPUTED]
          param.kernel_type = Libsvm::KernelType::RBF
          param.gamma = 0.01
          param
        end
      end

      def lag
        [ LAG, prediction_count.size - 1 ].min
      end

      def fractional_coef
        1000000
      end
    end
  end
end
