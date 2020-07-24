class RoomChannel < ApplicationCable::Channel
  STATUS_TALKING = 'Talking'
  STATUS_WAITING = 'Waiting'
  STATUS_FINISHED = 'Finished'

  def subscribed
    stream_from "start_#{params['room_id']}"
    stream_from "messages_#{params['room_id']}"
    stream_from "lines_#{params['room_id']}"
    stream_from "remove_#{params['room_id']}"

    @user = User.find_by(user_id: params['user_id'])

    return if @user.blank?

    count = User.where(room_id: params['room_id']).count

    @room = Room.find_by(id: params['room_id'])

    # roomの人数によりstatus更新
    case count
    when 1 then @room.status = STATUS_WAITING
    when 2 then
      @room.status = STATUS_TALKING
      startChat
    else
      @room.status = STATUS_FINISHED
    end

    @room.save
  end

  def unsubscribed
    @user = User.find_by(user_id: params['user_id'])
    @user.room_id = nil
    @user.save

    count = User.where(room_id: params['room_id']).count

    @room = Room.find_by(id: params['room_id'])

    # roomの人数によりstatus更新
    case count
    when 1 then
      @room.status = STATUS_FINISHED
      removeRoom
    when 2 then @room.status = STATUS_TALKING
    else 
      @room.status = STATUS_FINISHED
    end

    @room.save
  end

  def startChat
    ActionCable.server.broadcast "start_#{params['room_id']}", { action: 'start' }
  end

  def removeRoom
    ActionCable.server.broadcast "remove_#{params['room_id']}", { action: 'remove' }
  end
end
