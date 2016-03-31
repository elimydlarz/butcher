# Butcher

Your friendly, local meet(up) corner shop. Fresh produce delivered to your email.


## Testing

```
rspec
```

## Running Locally

```
MEETUP_API_KEY=<some legit meetup.com API key> ruby app/butcher.rb
```
Then navigate to: `http://localhost:4567/?latitude=-33.865143&longitude=151.209900&radius=20.0`

## Configuration

Deployed, Butcher requires the following environment variables:

- `MEETUP_API_KEY`

Optionally, the following defaults can be set:

- `LOCATION_LATITUDE`
- `LOCATION_LONGITUDE`
- `LOCATION_RADIUS_MILES`