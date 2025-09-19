CREATE OR REPLACE PACKAGE pkg_pedidos IS

  FUNCTION calcular_total_pedido(p_id_pedido NUMBER) RETURN NUMBER;

  PROCEDURE agregar_linea(
    p_id_pedido   IN NUMBER,
    p_id_producto IN NUMBER,
    p_cantidad    IN NUMBER
  );


  PROCEDURE validar_y_recalcular_total(p_id_pedido IN NUMBER);
END pkg_pedidos;
/



CREATE OR REPLACE PACKAGE BODY pkg_pedidos IS


  FUNCTION calcular_total_pedido(p_id_pedido NUMBER) RETURN NUMBER IS
    v_total NUMBER;
  BEGIN
    SELECT SUM(d.CANTIDAD * p.PRECIO)
      INTO v_total
      FROM PEDIDO_DETALLE d
      JOIN PRODUCTO p ON p.ID_PRODUCTO = d.ID_PRODUCTO
     WHERE d.ID_PEDIDO = p_id_pedido;

    RETURN NVL(v_total, 0);
  END calcular_total_pedido;


  PROCEDURE agregar_linea(
    p_id_pedido   IN NUMBER,
    p_id_producto IN NUMBER,
    p_cantidad    IN NUMBER
  ) IS
    v_total NUMBER;
  BEGIN
    INSERT INTO PEDIDO_DETALLE (ID_PEDIDO, ID_PRODUCTO, CANTIDAD)
    VALUES (p_id_pedido, p_id_producto, p_cantidad);

    UPDATE PEDIDO
       SET TOTAL = calcular_total_pedido(p_id_pedido)
     WHERE ID_PEDIDO = p_id_pedido;

    v_total := calcular_total_pedido(p_id_pedido);
    DBMS_OUTPUT.PUT_LINE('Pedido '||p_id_pedido||' actualizado. Producto '||p_id_producto||' x' || p_cantidad ||'. Nuevo total = ' || v_total);
  END agregar_linea;


  PROCEDURE validar_y_recalcular_total(p_id_pedido IN NUMBER) IS
    ex_pedido_sin_detalle EXCEPTION;
    v_existe NUMBER;
    v_count_det NUMBER;
    v_total NUMBER;
  BEGIN
  
    SELECT COUNT(*) INTO v_existe
    FROM PEDIDO
    WHERE ID_PEDIDO = p_id_pedido;

    IF v_existe = 0 THEN
      RAISE NO_DATA_FOUND;
    END IF;


    SELECT COUNT(*) INTO v_count_det
    FROM PEDIDO_DETALLE
    WHERE ID_PEDIDO = p_id_pedido;

    IF v_count_det = 0 THEN
      RAISE ex_pedido_sin_detalle;
    END IF;

 
    v_total := calcular_total_pedido(p_id_pedido);

    UPDATE PEDIDO
       SET TOTAL = v_total
     WHERE ID_PEDIDO = p_id_pedido;

    DBMS_OUTPUT.PUT_LINE('Validación OK. Total recalculado = '||v_total);

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No existe el pedido '||p_id_pedido||'.');
    WHEN ex_pedido_sin_detalle THEN
      DBMS_OUTPUT.PUT_LINE('Pedido '||p_id_pedido||' no tiene líneas.');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error inesperado: '||SQLERRM);
  END validar_y_recalcular_total;

END pkg_pedidos;
/
