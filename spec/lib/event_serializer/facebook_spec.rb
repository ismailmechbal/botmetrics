RSpec.describe EventSerializer::Facebook do
  let!(:timestamp)    { Time.now.to_i * 1000 }

  describe '.new' do
    context 'invalid params' do
      it { expect { EventSerializer::Facebook.new(nil, 'bi_uid') }.to raise_error('Supplied Option Is Nil') }
    end
  end

  describe '#serialize' do
    subject { EventSerializer::Facebook.new(data, 'bi_uid').serialize }

    let(:data) {
      {
        "entry": [{
          "id": "268855423495782", "time": 1470403317713, "messaging": [{
            "sender":{
              "id":"USER_ID"
            },
            "recipient":{
              "id":"PAGE_ID"
            },
            "timestamp":timestamp,
            "#{event_type}":{
              "mid":"mid.1457764197618:41d102a3e1ae206a38",
              "seq":73,
              "text":"hello, world!",
              "quick_reply": {
                "payload": "DEVELOPER_DEFINED_PAYLOAD"
              }
            }
          }]
        }]
      }
    }
    let(:serialized) {
      [{
        data:  {
          event_type: 'message',
          is_for_bot: true,
          is_im: true,
          is_from_bot: false,
          text: "hello, world!",
          provider: "facebook",
          created_at: Time.at(timestamp.to_f / 1000),
          event_attributes: {
            mid: "mid.1457764197618:41d102a3e1ae206a38",
            seq: 73,
            quick_reply: "DEVELOPER_DEFINED_PAYLOAD"}},
        recip_info: {
          sender_id: "USER_ID", recipient_id: "PAGE_ID"
        }
      }]
    }

    context 'incorrect event type' do
      let(:event_type) { 'incorrect' }

      it { expect { EventSerializer::Facebook.new(data, 'bi_uid').serialize }.to raise_error('Incorrect Event Type') }
    end

    context 'correct event type' do
      let(:event_type) { 'message' }

      it { expect(subject).to eql serialized }
    end
  end
end
