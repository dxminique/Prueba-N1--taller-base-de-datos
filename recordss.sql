SET SERVEROUTPUT ON;

DECLARE

  TYPE t_producto_rec IS RECORD (
    id     PRODUCTO.ID_PRODUCTO%TYPE,
    nombre PRODUCTO.NOMBRE%TYPE,
    precio PRODUCTO.PRECIO%TYPE,
    stock  PRODUCTO.STOCK%TYPE
  );

  v_prod t_producto_rec;
BEGIN

  SELECT p.ID_PRODUCTO, p.NOMBRE, p.PRECIO, p.STOCK
  INTO   v_prod
  FROM   PRODUCTO p
  WHERE  p.ID_PRODUCTO = 13;

  DBMS_OUTPUT.PUT_LINE(
    'Producto '||v_prod.id||' - '||v_prod.nombre||' | Precio: '||v_prod.precio||' | Stock: '||v_prod.stock
  );
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No existe el producto con ese ID.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: '||SQLERRM);
END;
/
