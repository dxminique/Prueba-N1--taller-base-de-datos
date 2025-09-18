SET SERVEROUTPUT ON;

DECLARE
 
  TYPE t_productos IS VARRAY(5) OF VARCHAR2(100);
  v_lista t_productos := t_productos('Tomate', 'Lechuga', 'Zanahoria');

BEGIN

  FOR i IN 1 .. v_lista.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Producto ' || i || ': ' || v_lista(i));
  END LOOP;
END;
/


-- datos producto

DECLARE

  TYPE t_productos IS VARRAY(5) OF VARCHAR2(100);
  v_lista t_productos;
BEGIN

  SELECT NOMBRE
  BULK COLLECT INTO v_lista
  FROM PRODUCTO
  WHERE ROWNUM <= 5;


  FOR i IN 1 .. v_lista.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Producto ' || i || ': ' || v_lista(i));
  END LOOP;
END;
/


--listar productos usuarios



DECLARE

  v_email    VARCHAR2(120) := 'ana@mail.com';


  v_id_usuario  NUMBER;


  TYPE t_pedidos IS VARRAY(10) OF NUMBER;
  v_peds  t_pedidos;


  CURSOR c_det(p_pedido NUMBER) IS
    SELECT pr.NOMBRE,
           d.CANTIDAD,
           pr.PRECIO,
           (d.CANTIDAD * pr.PRECIO) AS SUBTOTAL
    FROM PEDIDO_DETALLE d
    JOIN PRODUCTO pr ON pr.ID_PRODUCTO = d.ID_PRODUCTO
    WHERE d.ID_PEDIDO = p_pedido;

  v_total NUMBER;
BEGIN

  SELECT ID_USUARIO INTO v_id_usuario
  FROM USUARIO
  WHERE EMAIL = v_email
  FETCH FIRST 1 ROWS ONLY;


  SELECT ID_PEDIDO
  BULK COLLECT INTO v_peds
  FROM PEDIDO
  WHERE ID_USUARIO = v_id_usuario
  ORDER BY ID_PEDIDO
  FETCH FIRST 10 ROWS ONLY;

  IF v_peds IS NULL OR v_peds.COUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE('El usuario '||v_email||' no tiene pedidos.');
    RETURN;
  END IF;

  -- 3) Recorrer el VARRAY y, para cada pedido, usar el cursor con parámetro
  FOR i IN 1 .. v_peds.COUNT LOOP
    v_total := 0;
    DBMS_OUTPUT.PUT_LINE('--- Pedido '||v_peds(i)||' ---');

    FOR r IN c_det(v_peds(i)) LOOP
      DBMS_OUTPUT.PUT_LINE('  '||r.NOMBRE||' x' || r.CANTIDAD ||'  (precio '|| r.PRECIO || ')  = ' || r.SUBTOTAL);
      v_total := v_total + r.SUBTOTAL;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total pedido '|| v_peds(i) || ': ' || NVL(v_total,0));
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No existe el email '||v_email||' en USUARIO.');
END;
/


BEGIN
  pkg_pedidos.agregar_linea(21, 13, 2);  
END;
/



