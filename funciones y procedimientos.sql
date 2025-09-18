--- funcion para calcular total del pedido

CREATE OR REPLACE FUNCTION calcular_total_pedido(p_id_pedido NUMBER)
RETURN NUMBER IS v_total NUMBER;
BEGIN
  SELECT SUM(d.CANTIDAD * p.PRECIO) INTO v_total
  FROM PEDIDO_DETALLE d JOIN PRODUCTO p ON p.ID_PRODUCTO = d.ID_PRODUCTO
  WHERE d.ID_PEDIDO = p_id_pedido;
  RETURN NVL(v_total, 0);
END;
/


-- agregar línea y actualizar total

CREATE OR REPLACE PROCEDURE agregar_linea(
  p_id_pedido   IN NUMBER,
  p_id_producto IN NUMBER,
  p_cantidad    IN NUMBER
) IS
BEGIN
  INSERT INTO PEDIDO_DETALLE (ID_PEDIDO, ID_PRODUCTO, CANTIDAD)
  VALUES (p_id_pedido, p_id_producto, p_cantidad);

  UPDATE PEDIDO
     SET TOTAL = calcular_total_pedido(p_id_pedido)
   WHERE ID_PEDIDO = p_id_pedido;
END;
/
