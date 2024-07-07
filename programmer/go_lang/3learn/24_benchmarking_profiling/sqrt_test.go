package sqrt

import (
	"fmt"
	"testing"
)

func almostEqual(a, b float64) bool {
	return Abs(a-b) < 0.001
}

func TestSimple(t *testing.T) {
	val, err := Sqrt(2)

	if err != nil {
		t.Fatalf("error in calculation: %s", err)
	}

	if !almostEqual(val, 1.414214) {
		t.Fatalf("bad value - %f", val)
	}
}

type testCase struct {
	value    float64
	expected float64
}

func TestMany(t *testing.T) {
	testCases := []testCase{
		{0.0, 0.0},
		{2.0, 1.414214},
		{9.0, 3.0},
	}

	for _, tc := range testCases {
		t.Run(fmt.Sprintf("%f", tc.value), func(t *testing.T) {
			out, err := Sqrt(tc.value)
			if err != nil {
				t.Fatal("error")
			}
			if !almostEqual(out, tc.expected) {
				t.Fatalf("%f != %f", out, tc.expected)
			}
		})
	}
}

func BenchmarkSqrt(b *testing.B) {
	for i := 0; i < b.N; i++ {
		_, err := Sqrt(float64(i))
		if err != nil {
			b.Fatal(err)
		}
	}
}

// BENCHAMRKING:
// $ go test -v -bench .
// $ go test -v -bench . -run A

// PROFILING:
// $ go test -v -bench . -run A -cpuprofile=prof.out
// $ go tool pprof prof.out
// list Sqrt
// list Abs
