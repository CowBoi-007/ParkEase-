from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# 50 demo spots, all available
spots = [
    {'id': f'S{i+1}', 'name': f'Spot {i+1}', 'occupied': False}
    for i in range(50)
]

@app.route("/api/spots", methods=["GET"])
def get_all_spots():
    return jsonify(spots)

@app.route("/api/spots/<spot_id>", methods=["GET"])
def get_spot(spot_id):
    spot = next((s for s in spots if s['id'] == spot_id), None)
    if spot:
        return jsonify(spot)
    return jsonify({'error': 'Spot not found'}), 404

@app.route("/api/spots/<spot_id>/assign", methods=["POST"])
def assign_spot(spot_id):
    spot = next((s for s in spots if s['id'] == spot_id), None)
    if not spot:
        return jsonify({'error': 'Spot not found'}), 404
    if spot['occupied']:
        return jsonify({'error': 'Spot already occupied'}), 400
    spot['occupied'] = True
    return jsonify({'message': 'Spot assigned', 'spot': spot})

@app.route("/api/spots/<spot_id>/free", methods=["POST"])
def free_spot(spot_id):
    spot = next((s for s in spots if s['id'] == spot_id), None)
    if not spot:
        return jsonify({'error': 'Spot not found'}), 404
    spot['occupied'] = False
    return jsonify({'message': 'Spot freed', 'spot': spot})

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)

