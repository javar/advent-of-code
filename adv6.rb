data = File.read(ARGV[0]).strip
lines = data.split("\n")
ans = 0

t, d = lines
times = t.split(":")[1].split().map(&:to_i)
dist = d.split(":")[1].split().map(&:to_i)

time = times.join.to_i
distance = dist.join.to_i

def f(t, d)
  ans = 0
  (t + 1).times do |x|
    dx = x * (t - x)
    ans += 1 if dx >= d
  end
  ans
end

ans = 1
times.each_with_index do |t, i|
  ans *= f(t, dist[i])
end

puts ans
puts f(time, distance)
