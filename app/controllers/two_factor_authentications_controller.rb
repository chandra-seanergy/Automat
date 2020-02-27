class TwoFactorAuthenticationsController < ApplicationController
  before_action :authenticate_user!

  # Generate and provide QR Code to enable two factor authentication for user
  def fetch_qr
    qrcode = RQRCode::QRCode.new(current_user.provisioning_uri, size: 10, level: :h )
    png = qrcode.as_png(bit_depth: 1, border_modules: 4, color_mode: ChunkyPNG::COLOR_GRAYSCALE, color: 'black', file: nil, fill: 'white', module_px_size: 6, resize_exactly_to: false, resize_gte_to: false)
    user_id = current_user.id
    image_path = Rails.root.join("public/#{user_id}.png")
    File.open(image_path, 'wb'){|image_file| image_file.write png }
    render json: {status: 200, message: "QR fetched", qr: "#{user_id}.png", key: current_user.otp_secret_key.scan(/.{4}/).join(' ')}
  end

  # Recieve OTP code and enable two factor authentication
  def enable_two_factor_authentication
    if current_user.authenticate_otp(params[:user][:otp_code], drift: 60)
      current_user.otp_module_enabled!
      render json: {status: 200, message: "Two factor authentication enabled successfully."}
    else
      render json: {status: 500, message: "Invalid two-factor code."}
    end
  end

  # Disable two factor authentication for user
  def disable_two_factor_authentication
    if current_user.otp_module_disabled!
      render json: {status: 200, message: "Two factor authentication disabled successfully."}
    else
      render json: {status: 500, message: "Error."}
    end
  end
end