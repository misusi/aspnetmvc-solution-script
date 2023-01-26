using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace <ProjectName>.Data.Repository.IRepository
{
    public interface IUnitOfWork
    {
	//I<ModelName>Repository ModelName { get; }
        void Save();
    }
}
