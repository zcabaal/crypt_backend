describe Models::Transaction do

  it 'is embedded inside a sender'
  it 'has a receiver which is a user id'
  it 'has an amount which is a decimal number'
  it 'has a sent at time'
  it 'has a received at time'
  it 'has a cryptographically secure token for the receiver (before the receiver signs up)'
  it 'has encrypted payment details'

  it 'has a flag to show if it is partial (i.e no receiver)'
  it 'has a flag to show if it was processed'
  it 'has a flag to show if it is rejected (because the cap is reached)'
  it 'has a flag to show if it is refunded'
end