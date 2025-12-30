struct VertexOutput {
    @builtin(position) pos: vec4<f32>,
    @location(0) uv: vec2<f32>,
};

@vertex
fn vs_main(@builtin(vertex_index) vertex_index: u32) -> VertexOutput {
    var pos = array<vec2<f32>, 3>(
        vec2<f32>(0.0, 0.5),    // 顶点
        vec2<f32>(-0.5, -0.5),  // 左下
        vec2<f32>(0.5, -0.5),   // 右下
    );

    let uv_coords = array(
        vec2<f32>(0.0, 1.0),
        vec2<f32>(1.0, 1.0),
        vec2<f32>(0.0, 0.0),
        vec2<f32>(1.0, 0.0),
    );

    var output: VertexOutput;
    output.pos = vec4<f32>(pos[vertex_index], 0.0, 1.0);
    output.uv = uv_coords[vertex_index];
    return output;
}

fn nextRandom(seed: ptr<function, u32>) -> u32 {
    *seed = *seed * 1103515245u + 12345u;
    return *seed >> 16u;
}

fn random(seed: ptr<function, u32>) -> f32 {
    return f32(nextRandom(seed)) / 65536.0;
}

fn sinRand(co: vec2<f32>) -> f32 {
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

// PCG
fn rand(state: ptr<function, u32>) -> f32 {
    *state = *state * 747796405u + 2891336453u;
    var result: u32 = ((*state >> ((*state >> 28u) + 4u)) ^ *state) * 277803737u;
    result = (result >> 22u) ^ result;
    return f32(result) / 4294967296.0;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // let uv = in.uv;
    // let color = vec3<f32>(uv.x, uv.y, 0.5);
    // let color = vec3<f32>(sinRand(uv.xy));
    let pos = in.pos;
    let numPixels = pos.xy;
    let pixelIndex = pos.x * 800.0 + pos.y; // 假设宽度为800
    // var seed: u32 = u32((pos.x + 1.0) * 1000.0) ^ u32((pos.y + 1.0) * 1000.0);
    var seed: u32 = u32(pixelIndex);
    let r = rand(&seed);
    let g = rand(&seed);
    let b = rand(&seed);
    return vec4<f32>(r, g, b, 1.0);
}