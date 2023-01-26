//using <ProjectName>.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace <ProjectName>.Data
{
    public class ApplicationDbContext : IdentityDbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }
        //public DbSet<Category> Categories { get; set; }
        //public DbSet<ApplicationUser> ApplicationUsers { get; set; }
    }
}
