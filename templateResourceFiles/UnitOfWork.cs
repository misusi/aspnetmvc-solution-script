using <ProjectName>.Data;
using <ProjectName>.Data.Repository.IRepository;
//using <ProjectName>.Models;
using Microsoft.EntityFrameworkCore.Metadata;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace <ProjectName>.Data.Repository
{
    public class UnitOfWork : IUnitOfWork
    {
        private ApplicationDbContext _db;
        public UnitOfWork(ApplicationDbContext db)
        {
            _db = db;
            //Category = new CategoryRepository(_db);
            //ApplicationUser = new ApplicationUserRepository(_db);
        }

        //public ICategoryRepository Category { get; private set; }
        //public IApplicationUserRepository ApplicationUser { get; private set; }
        public void Save()
        {
            _db.SaveChanges();
        }
    }
}
