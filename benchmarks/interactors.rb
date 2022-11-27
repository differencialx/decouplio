# frozen_string_literal: true

require 'interactor'

class InteractorStepsService
  include Interactor

  def call
    step_one
    step_two
    step_three
    step_four
    step_five
    step_six
    step_seven
    step_eight
    step_nine
    step_ten
  end

  def step_one
    context.step_one = context.initial_param
  end

  def step_two
    context.step_two = context.step_one
  end

  def step_three
    context.step_three = context.step_two
  end

  def step_four
    context.step_four = context.step_three
  end

  def step_five
    context.step_five = context.step_four
  end

  def step_six
    context.step_six = context.step_five
  end

  def step_seven
    context.step_seven = context.step_six
  end

  def step_eight
    context.step_eight = context.step_seven
  end

  def step_nine
    context.step_nine = context.step_eight
  end

  def step_ten
    context.step_ten = context.step_nine
  end
end

class StepOne
  include Interactor

  def call
    context.step_one = context.initial_param
  end
end

class StepTwo
  include Interactor

  def call
    context.step_two = context.step_one
  end
end

class StepThree
  include Interactor

  def call
    context.step_three = context.step_two
  end
end

class StepFour
  include Interactor

  def call
    context.step_four = context.step_three
  end
end

class StepFive
  include Interactor

  def call
    context.step_five = context.step_four
  end
end

class StepSix
  include Interactor

  def call
    context.step_six = context.step_five
  end
end

class StepSeven
  include Interactor

  def call
    context.step_seven = context.step_six
  end
end

class StepEight
  include Interactor

  def call
    context.step_eight = context.step_seven
  end
end

class StepNine
  include Interactor

  def call
    context.step_nine = context.step_eight
  end
end

class StepTen
  include Interactor

  def call
    context.step_ten = context.step_nine
  end
end

class InteractorWithOrganizer
  include Interactor::Organizer

  organize StepOne,
           StepTwo,
           StepThree,
           StepFour,
           StepFive,
           StepSix,
           StepSeven,
           StepEight,
           StepNine,
           StepTen
end
