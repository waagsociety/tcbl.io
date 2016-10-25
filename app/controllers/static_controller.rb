class StaticController < ApplicationController

  def home
  end

  def about
  end

  def what
  end

  def embed_what
	render :what, layout: false
  end

  def principles
  end

  def country_guess
    render text: (current_country ? "I think you are in #{current_country}" : "I don't know where you are")
  end

  def api
    render :api, layout: false
  end

  def choose_locale
    render :choose_locale, layout: !request.xhr?
    # if request.xhr?

    # else
    #   redirect_to request.referer, params: { locale: I18n.locale }
    # end
  end
end
