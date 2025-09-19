SET SERVEROUTPUT ON;

DECLARE
  v_prod PRODUCTO%ROWTYPE;
BEGIN
  SELECT * INTO v_prod
  FROM PRODUCTO
  WHERE ID_PRODUCTO = 13;  -- usa un ID válido de tu tabla PRODUCTO

  DBMS_OUTPUT.PUT_LINE(
    'ROWTYPE -> '||v_prod.NOMBRE||
    ' | Precio: '||v_prod.PRECIO||
    ' | Stock: '||v_prod.STOCK
  );
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No existe el producto con ese ID.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: '||SQLERRM);
END;
/
