# PHP

PHP (PHP: Hypertext Preprocessor; in origin, PHP stands for Personal Home Page tools) is a popular server-side scripting
language (although it's a multipurpose scripting language).

- [Setup environment](setup.md)
- [Data types](#data-types)
    - [Primitive](#primitive)
        - [Scalar](#scalar)
        - [Compound](#compound)
        - [Special](#special)
    - [Type casting](#type-casting)
- [Block](#block)
- [Variable](#variable)
    - [Global variables](#global-variables)
- [Statements](#statements)
- [Flow controlling](#flow-controlling)
- [Functions](#functions)

## Data types

### Primitive

#### Scalar

- bool
- int
- float
- string

#### Compound

- array
- object
- callable
- iterable

#### Special

- resource
- NULL
- Boolean
- Integer
- Floating-point number
- String
- Numeric string
- Array
- Iterable
- Object
- Enumeration
- Resource
- NULL
- Callbacks / Callable

### Type casting

Use the cast syntax or [settype()](#settype) functions.

```php
$var = 10;  // integer
$var = (bool) $var  // cast to bool
```

#### Support casting types

- `int`
- `bool`
- `float`
- `string`
- `array`
- `object`
- `unset`: to `NULL`

## Literals

### Numeric literal

```php
10
10.1
```

### String literal

```php
'Hello'
```

#### String template

```php
"Hello $var"
```

where

- `$var`: a variable

## Block

### Syntax

```php
<?php ... ?>
```

## Variable

Variable type in PHP is dynamic.

### Syntax

```php
$var
```

### Global variables

#### $_SERVER

`$_SERVER` contains all web server information.

##### HTTP_USER_AGENT

Returns the user agent.

```php
$_SERVER['HTTP_USER_AGENT']
```

## Statements

### echo

```php
echo 'message';
```

## Flow controlling

### if statement

```php
if (bool $condition) {
  ...
} else if {
  ...
} else {
  ...
}
```

#### Nested if

```php
if () {
  if () {
    ...
  } else {
    ...
  }
} else {
  ...
}
```

## Functions

### gettype

Returns the string that represents the type of a variable.

```php
gettype($var): string
```

| Value             | Types    |
|-------------------|----------|
| boolean           | bool     |
| integer           | int      |
| double            | float    |
| string            | string   |
| array             | array    |
| object            | object   |
| resource          | resource |
| resource (closed) | resource |
| NULL              | NULL     |
| unknown type      |          |

### settype

Try to convert type of a variable, if success, returns true; otherwise, false.

```php
settype($var, string $type): bool
```

where

- `$type`: one of
    - `'bool'`
    - `'int'`
    - `'float'` or `'double'`
    - `'string'`
    - `'array'`
    - `'object'`
    - `'null'`

### is_string

Check if the input is a string or not.

```php
is_string($var): bool
```

### phpinfo

```php
phpinfo();
```

### strpos

Returns the first found index or `false`.

```php
strpos(string $haystack, string $needle, int $offset = 0): int|false
```

where

- `$haystack`: search in.
- `$needle`: search this.
- `$offset`: start index.

#### Example

```php
if (strpos($_SERVER['HTTP_USER_AGENT'], 'Firefox')) !== false) {
    echo 'Firefox';
}
```

### str_starts_with

*(PHP 8)*

Check if a given string starts with another given string.

```php
str_starts_with(string $haystack, string $needle): bool
```

### str_ends_with

*(PHP 8)*

Check if a given string ends with another given string.

```php
str_ends_with(string $haystack, string $needle): bool
```

### strtoupper

Transform a specific string to all uppercase characters.

```php
strtoupper(string $string): string
```

### mb_strlen

Returns the number of characters in a given string.

```php
mb_strlen(string $string, ?string $encoding = null): int 
```

where

- `$encoding`: if null, the return value of [mb_internal_encoding()](#mb_internal_encoding) will be used.

### mb_internal_encoding

Get or set the internal encoding of the `mbstring` module.

```php
mb_internal_encoding(?string $encoding = null): string|bool throws ValueError
```

where

- `$encoding`: if null, returns the current internal encoding. Otherwise, replaces the internal encoding with the given
  encoding; returns the replacement result (true|false).
- `ValueError`: will be thrown in the case the given encoding is invalid.







