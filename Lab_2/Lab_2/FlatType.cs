using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab_2
{
    class FlatType
    {
        private int flatTypeId;
        private string flatTypeName;

        public int FlatTypeId
        {
            get { return flatTypeId; }
            set { flatTypeId = value; }
        }
        public string FlatTypeName
        {
            get { return flatTypeName; }
            set { flatTypeName = value; }
        }
    }
}
