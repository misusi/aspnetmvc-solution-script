using <ProjectName>.Data;
using <ProjectName>.Data.Repository;
using <ProjectName>.Data.Repository.IRepository;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI.Services;
//using <ProjectName>.Utility;
//using Stripe;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();
builder.Services.AddRazorPages();
builder.Services.AddDbContext<ApplicationDbContext>(options => options.UseSqlServer(
    builder.Configuration.GetConnectionString("DefaultConnection")
    ));
//builder.Services.Configure<StripeSettings>(builder.Configuration.GetSection("Stripe"));

//builder.Services.AddDefaultIdentity<IdentityUser>(options => options.SignIn.RequireConfirmedAccount = true)
//.AddEntityFrameworkStores<ApplicationDbContext>();
builder.Services.AddIdentity<IdentityUser, IdentityRole>()
    .AddDefaultTokenProviders()
    .AddEntityFrameworkStores<ApplicationDbContext>();
builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();
//builder.Services.AddSingleton<IEmailSender, EmailSender>();
//builder.Services.AddAuthentication().AddFacebook(options => {
//    options.AppId = "111111111111111";
//    options.AppSecret = "1111111111111111";
//});

builder.Services.ConfigureApplicationCookie(options =>
{
    options.LoginPath = $"/Identity/Account/Login";
    options.LogoutPath = $"/Identity/Account/Logout";
    options.AccessDeniedPath = $"/Identity/Account/AccessDenied";
});
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(100);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

var app = builder.Build();

// Configure the HTTP request pipeline.
// Middleware
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}
else
{
    app.UseDeveloperExceptionPage();
}


app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

// StripeConfiguration.ApiKey = builder.Configuration.GetSection("Stripe:SecretKey").Get<string>();

app.UseAuthentication();
app.UseAuthorization();
app.UseSession();
app.MapRazorPages();
app.MapControllerRoute(
    name: "default",
    pattern: "{area=User}/{controller=Home}/{action=Index}/{id?}");

app.Run();