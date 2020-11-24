//Rotations[<Piece>][<Rotation>][<Mino>]
// ██ == centerpoint from which these vectors are offsets from (aka. the (0,0) vector)
// ▓▓ == locations relative to the centerpoint which these vectors represent
// X axis increases from left --> right (+1 = 1 unit to the right)
// Y axis increases from  up  --> down  (+1 = 1 unit below)
PVector[][][] Rotation_Tables = {
  {  //O
    {
    new PVector(0,0),
    new PVector(1,0),  // ▓▓▓▓
    new PVector(0,-1), // ██▓▓
    new PVector(1,-1)
    },
    {
    new PVector(0,0),
    new PVector(1,0),  // ▓▓▓▓
    new PVector(0,-1), // ██▓▓
    new PVector(1,-1)
    },
    {
    new PVector(0,0),
    new PVector(1,0),  // ▓▓▓▓
    new PVector(0,-1), // ██▓▓
    new PVector(1,-1)
    },
    {
    new PVector(0,0),
    new PVector(1,0),  // ▓▓▓▓
    new PVector(0,-1), // ██▓▓
    new PVector(1,-1)
    }
  },
  
  {  //T
    {
    new PVector(0,0),
    new PVector(-1,0), //   ▓▓
    new PVector(1,0),  // ▓▓██▓▓
    new PVector(0,-1)
    },
    {
    new PVector(0,0),
    new PVector(0,-1), // ▓▓
    new PVector(0,1),  // ██▓▓
    new PVector(1,0)   // ▓▓
    },
    {
    new PVector(0,0),
    new PVector(1,0),  // ▓▓██▓▓
    new PVector(-1,0), //   ▓▓
    new PVector(0,1)
    },
    {
    new PVector(0,0),
    new PVector(0,1),  //   ▓▓
    new PVector(0,-1), // ▓▓██
    new PVector(-1,0)  //   ▓▓
    }
  },
  
  {  //L
    {
    new PVector(-1,0),
    new PVector(0,0),  //     ▓▓
    new PVector(1,0),  // ▓▓██▓▓
    new PVector(1,-1)
    },
    {
    new PVector(0,-1),
    new PVector(0,0),  // ▓▓
    new PVector(0,1),  // ██
    new PVector(1,1)   // ▓▓▓▓
    },
    {
    new PVector(1,0),
    new PVector(0,0),  // ▓▓██▓▓
    new PVector(-1,0), // ▓▓
    new PVector(-1,1) 
    },
    {
    new PVector(0,1),
    new PVector(0,0),  // ▓▓▓▓
    new PVector(0,-1), //   ██
    new PVector(-1,-1) //   ▓▓
    }
  },
  
  {  //J
    {
    new PVector(-1,-1),
    new PVector(-1,0), // ▓▓
    new PVector(0,0),  // ▓▓██▓▓
    new PVector(1,0)
    },
    {
    new PVector(1,-1),
    new PVector(0,-1), // ▓▓▓▓
    new PVector(0,0),  // ██
    new PVector(0,1)   // ▓▓
    },
    {
    new PVector(1,1),
    new PVector(1,0), // ▓▓██▓▓
    new PVector(0,0), //     ▓▓
    new PVector(-1,0)
    },
    {
    new PVector(-1,1),
    new PVector(0,1), //   ▓▓
    new PVector(0,0), //   ██
    new PVector(0,-1) // ▓▓▓▓
    }
  },
  
  {  //S
    {
    new PVector(-1,0),
    new PVector(0,0),  //   ▓▓▓▓
    new PVector(0,-1), // ▓▓██
    new PVector(1,-1)
    },
    {
    new PVector(0,-1),
    new PVector(0,0), // ▓▓
    new PVector(1,0), // ██▓▓
    new PVector(1,1)  //   ▓▓
    },
    {
    new PVector(1,0),
    new PVector(0,0), //   ██▓▓
    new PVector(0,1), // ▓▓▓▓
    new PVector(-1,1)
    },
    {
    new PVector(0,1),
    new PVector(0,0),  // ▓▓
    new PVector(-1,0), // ▓▓██
    new PVector(-1,-1) //   ▓▓
    }
  },
  
  {  //Z
    {
    new PVector(1,0),
    new PVector(0,0),  // ▓▓▓▓
    new PVector(0,-1), //   ██▓▓
    new PVector(-1,-1)
    },
    {
    new PVector(0,1),
    new PVector(0,0), //   ▓▓
    new PVector(1,0), // ██▓▓
    new PVector(1,-1) // ▓▓
    },
    {
    new PVector(-1,0),
    new PVector(0,0), // ▓▓██
    new PVector(0,1), //   ▓▓▓▓
    new PVector(1,1)
    },
    {
    new PVector(0,-1),
    new PVector(0,0),  //   ▓▓
    new PVector(-1,0), // ▓▓██
    new PVector(-1,1)  // ▓▓
    }
  },
  
  {  //I
    {
    new PVector(1,0),
    new PVector(0,0),
    new PVector(-1,0), // ▓▓▓▓██▓▓
    new PVector(-2,0)
    },
    {
    new PVector(0,1),  // ▓▓
    new PVector(0,0),  // ▓▓
    new PVector(0,-1), // ██
    new PVector(0,-2)  // ▓▓
    },
    {
    new PVector(-1,0),
    new PVector(0,0),
    new PVector(1,0),  // ▓▓██▓▓▓▓
    new PVector(2,0)
    },
    {
    new PVector(0,-1), // ▓▓
    new PVector(0,0),  // ██
    new PVector(0,1),  // ▓▓
    new PVector(0,2)   // ▓▓
    }
  }
};


