# dineq_restaurant

Inspiration 🌟  

If there’s one thing we can all agree to universally hate, it’s standing in lines. Imagine if you craved the famous pasta at your favorite Italian place, but the massive queue out front sent you home with a microwave meal instead? We’ve been there too many times, and we want to break ground on a potential solution. Hence, DineQ - our attempt at making dining as hassle-free as possible. And yes, it eliminates the need to stand in ever-extending lines!

What it does ⚡  

DineQ is the ultimate end-to-end dining experience that redefines convenience. Say farwell to tiresome lines, thanks to our virtual queue feature. Join the queue from wherever you are, and stay updated about your queue position and available seating in real time. And here's the best part, DineQ will let you know when you can head to the restaurant!

But the excitement doesn't stop there. Once you're comfortably seated, our app takes center stage, simplifying every aspect of your dining experience. From placing your order to effortlessly managing your tab and making secure payments using your very own Unique Order ID, everything can be done from one convenient location. With DineQ, we've got your back, guaranteeing a seamless and uninterrupted dining experience from start to finish.

How we built it 🛠️  

In the process of building DineQ, we left no stone unturned as we covered every category suggested by Devpost for the ultimate hackathon challenge. Our aim was to truly revolutionize the in-person buyer and seller experience of dining.

From the moment users open our app, they are transported into a world of convenience and efficiency. Through geofencing technology and the Google Maps API, we provide real-time restaurant information, guiding users to the closest and most enticing dining options available.

But the real magic happens when users choose a restaurant and discover our game-changing feature—the virtual queue. Our custom-built API seamlessly manages a digital queue system, optimizing wait times and keeping users informed every step of the way.

On the user side, we integrated the Square Create Order API to generate smooth and effortless ordering experiences. Once patrons have indulged in their delectable meals, our integration with the Square Retrieve Order and Invoice APIs provides them with detailed, itemized bills, transforming the payment process into a seamless finale.

Not only did we cater to buyers, but we also crafted a powerful app for restaurant owners. Our specialized application allows them to effortlessly manage menus and inventories, using Square's Upsert Catalog, Change Inventory and Adjust Inventory Counts APIs. With DineQ, restaurant owners can stay in control, ensuring a dynamic and ever-evolving dining experience for their patrons.

And to complete the experience, we harnessed the magic of the Square Terminal API, combined with a unique Order ID generated within our app. This enables secure and hassle-free payments, leaving users with a sense of satisfaction and delight.

DineQ is the result of our unwavering commitment to revolutionize the dining experience. We've combined the power of cutting-edge APIs and technologies to create a platform that seamlessly connects buyers and sellers, offering a truly remarkable dining adventure. Join us on this exciting journey as we transform the way we dine, one extraordinary bite at a time.

Key Features and Future Prospects 🚀  

We take immense pride in the remarkable features we've developed for DineQ. These features are the heart and soul of our app, transforming the dining experience into something truly extraordinary:

Virtual Queue: Say goodbye to waiting in long queues outside your favorite restaurants. We understand the frustration, which is why we engineered a groundbreaking Virtual Queue feature. Patrons can join the roster for their preferred restaurants without physically standing in line, saving valuable time and enhancing the overall dining experience.

Unique Order ID: We've revolutionized the payment process by introducing a seamless and secure way to settle the bill. When patrons are done dining, we generate a Unique Order ID (UOI) for them. This ID acts as a digital token, which patrons can conveniently present to the host. The host then utilizes the UOI to effortlessly complete the payment process, ensuring a smooth and hassle-free transaction.

End-to-end Integration of Square APIs: We've seamlessly woven together a range of APIs from the Square API suite, creating an unparalleled end-to-end dining experience. By leveraging the power of these APIs, we've crafted a seamless flow that connects buyers, sellers, and staff, ensuring that every aspect of the dining journey is covered with precision and efficiency.

In the future, we have exciting plans to expand the capabilities of DineQ even further. We envision integrating the Subscriptions API, enabling interested restaurants to join the DineQ environment and offer subscription-based services. This will provide an additional layer of convenience and benefits to both restaurant owners and loyal patrons, elevating the dining experience to new heights.

At DineQ, we're dedicated to continuously enhancing the app's functionality, revolutionizing the way we dine and creating a lasting impact on the restaurant industry.    

ACCESS INSTRUCTIONS FOR DINEQ  

App platform: Android

  
User-Side Application  

Download and Install:   
Download the user-side DineQ application by clicking here. Install the application on your device. If any permissions are requested during installation, please allow them for the full functionality of the application.

Create an Account:   
Open the application and proceed to create an account. After account creation, log into your account.

Navigation and Functionality:   
The application is designed to show only the restaurants registered with DineQ. We've hardcoded four restaurant geolocations for this demonstration. Once logged in, you can join a virtual queue if seats are not readily available at your preferred restaurant. Upon joining the queue, you'll receive a notification with your queue position.

If you've already joined a queue, you'll see a notification about the same.
If seats are available, you'll receive a notification prompting you to head to the restaurant directly.
Once at the restaurant, you can browse the menu and add items to your cart. After verifying the total bill, you can place an order. Please note that it may take up to 5 seconds to place an order, so kindly wait for this duration before proceeding.
Proceed to the "View Tab" which displays the invoice containing all ordered items with respective prices and quantities, and the total amount due. Here, you'll also find a unique 6-digit code for making payment. Note this code down for future reference.  

  
Restaurant-Side Application
Download and Install:   
Download the user-side DineQ application by clicking here. Install the application on your device. If any permissions are requested during installation, please allow them for the full functionality of the application.

Menu Management:   
The staff at the restaurant can use this application to see the menu, add new items, and modify inventory counts.

Seat Management: Staff can release seats if a user arrives but hasn't placed an order yet. If a user has made a payment, the seats are automatically released, and the next user in the queue can be seated.

Payment Processing: Staff can navigate to the "Terminal Checkout" section of the app where they can enter the unique order identifier to complete the payment and order. Please note that these operations are executed in a sandbox environment. According to Square's rules, the test order should be less than 25$ for the payment status to be completed.
