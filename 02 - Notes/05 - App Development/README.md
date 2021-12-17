# App Dev

## Objectives:
1. JSP 

## [JSP](http://www.tutorialspoint.com/jsp/jsp_overview.htm)
> Collect input from users through Webpage `forms`  
> `present records` from a database or another source  
> and `create Webpages dynamically`.

### Example `JSP` with `Java`
```html
<html> 
    <head> <title> Hello </title> </head> 
    <body> 
        <% 
            if (request.getParameter(“name”) == null) { 
                out.println(“Hello World”); 
            }
            else { 
                out.println(“Hello, ” + request.getParameter(“name”)); 
            }
        %> 
    </body>
</html>
```

## [PHP](https://www.tutorialspoint.com/php/index.htm)
> Allows web developers to `create dynamic content` that `interacts with databases`

### Example `PHP` with `Java`
```html
<html> 
    <head> <title> Hello </title> </head> 
    <body> 
        <?php 
            if (!isset($_REQUEST[‘name’])) { 
                echo “Hello World”; 
            }
            else { 
                echo “Hello, ” + $_REQUEST[‘name’]; 
            }
        ?>
    </body>
</html>
```