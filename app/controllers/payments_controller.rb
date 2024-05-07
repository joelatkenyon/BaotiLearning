
class PaymentsController < ApplicationController
  before_action :authenticate_user! # Ensure user is authenticated before making a purchase

  def purchase_course
    course = Course.find(params[:course_id])
    amount = (course.price * 100).to_i # Convert price to cents

    begin
      charge = Stripe::Charge.create({
        amount: amount,
        currency: 'usd',
        source: params[:stripeToken],
        description: "Purchase of #{course.name}"
      })

      # Update user's balance
      current_user.balance -= course.price
      current_user.save

      # Handle successful purchase
      flash[:success] = "Course purchased successfully!"
      redirect_to courses_path
    rescue Stripe::CardError => e
      # Handle card errors
      flash[:error] = e.message
      redirect_to courses_path
    end
  end
end
