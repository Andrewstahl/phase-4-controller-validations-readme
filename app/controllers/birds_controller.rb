class BirdsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  # GET /birds
  def index
    birds = Bird.all
    render json: birds
  end

  # POST /birds
  def create
    bird = Bird.create!(bird_params)
    render json: bird, status: :created
  end

  # GET /birds/:id
  def show
    bird = find_bird
    render json: bird
  end

  # PATCH /birds/:id
  def update
    bird = find_bird
    bird.update!(bird_params)
    render json: bird
  end

  # DELETE /birds/:id
  def destroy
    bird = find_bird
    bird.destroy
    head :no_content
  end

  private

  def find_bird
    Bird.find(params[:id])
  end

  def bird_params
    params.permit(:name, :species, :likes)
  end

  def render_not_found_response
    render json: { error: "Bird not found" }, status: :not_found
  end

  def render_unprocessable_entity_response
    # This will return a JSON object in the body of the 
    # response with a key of errors pointing to a nested 
    # object where the keys are the invalid attributes, and 
    # values are the validation error messages
    render json: { errors:  invalid.record.errors }, status: :unprocessable_entity
    
    # We could also return a different format by using the 
    # #full_messages method to output an array of 
    # pre-formatted error messages:
    render json: { errors:  invalid.record.errors.full_messages }, status: :unprocessable_entity
  end



end
