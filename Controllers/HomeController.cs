using Microsoft.AspNetCore.Mvc;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using System.Collections.Generic;
using ConsumerApp.Models;
using Microsoft.AspNetCore.Mvc.ViewEngines;

namespace ConsumerApp.Controllers
{
    public class HomeController : Controller
    {
        private readonly IHttpClientFactory _httpClientFactory;

        public HomeController(IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory;
        }

        // ����������� ������ ���������
        public async Task<IActionResult> Index()
        {
            var client = _httpClientFactory.CreateClient("ProductApi");
            var response = await client.GetAsync("api/ProductApi");

            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                var products = JsonSerializer.Deserialize<List<Product>>(json, new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });
                return View(products);
            }

            return View(new List<Product>());
        }

        // ����������� ������� ��������
        public async Task<IActionResult> Details(int id)
        {
            var client = _httpClientFactory.CreateClient("ProductApi");
            var response = await client.GetAsync($"api/ProductApi/{id}");

            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                var product = JsonSerializer.Deserialize<Product>(json, new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });
                return View(product);
            }

            return NotFound();
        }

        // ����� ��� ���������� ������
        public IActionResult AddReview(int id)
        {
            return View(new Review { ProductId = id });
        }

        // ��������� �������� ������
        [HttpPost]
        public async Task<IActionResult> AddReview(Review review)
        {
            if (string.IsNullOrWhiteSpace(review.Content) || review.Content.Length < 5)
            {
                ModelState.AddModelError("Content", "����� ������ ��������� ������� 5 ��������.");
                return View(review);
            }

            var client = _httpClientFactory.CreateClient("ProductApi");
            var content = new StringContent(JsonSerializer.Serialize(review.Content), System.Text.Encoding.UTF8, "application/json");
            var response = await client.PostAsync($"api/ProductApi/{review.ProductId}/review", content);

            if (response.IsSuccessStatusCode)
            {
                return RedirectToAction("Details", new { id = review.ProductId });
            }

            ModelState.AddModelError("", "������ ��� ���������� ������.");
            return View(review);
        }
    }
}