class RoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "start_#{params['room_id']}"
    stream_from "messages_#{params['room_id']}"
    stream_from "lines_#{params['room_id']}"
    stream_from "remove_#{params['room_id']}"

    p '▽サブスクライブド▽'
    @user = User.find_by(user_id: params['user_id'])

    if @user
      count = User.where(room_id: params['room_id']).count

      @room = Room.find_by(id: params['room_id'])
      if count == 0
        @room.status = 'Finished'
        p 'Finished'
      elsif count == 1
        @room.status = 'Waiting'
        p 'Waiting'
      elsif count == 2
        @room.status = 'Plaing'
        p 'Playing'
        startChat()
      end

      @room.save
    end
    p '△サブスクライブド△'

  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    p '▽アンサブスクライブド▽'

    @user = User.find_by(user_id: params['user_id'])
    @user.room_id = nil
    @user.save

    count = User.where(room_id: params['room_id']).count

    @room = Room.find_by(id: params['room_id'])
    if count == 0
      @room.status = 'Finished'
      p 'Finished'
    elsif count == 1
      @room.status = 'Finished'
      p 'Finished'
      removeRoom()
    elsif count == 2
      @room.status = 'Playing'
      p 'Playing'
    end

    @room.save

    p '△アンサブスクライブド△'
  end

  def startChat
    ActionCable.server.broadcast "start_#{params['room_id']}",
    {action: 'start'}
  end

  def removeRoom
    ActionCable.server.broadcast "remove_#{params['room_id']}",
    {action: 'remove'}
  end
end
