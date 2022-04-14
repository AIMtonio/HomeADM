-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMCUENTASORIGENLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMCUENTASORIGENLIS`;DELIMITER $$

CREATE PROCEDURE `BAMCUENTASORIGENLIS`(
-- SP lista las cuentas cargo de un cliente
	Par_ClienteID		INT(11),				-- ID del cliente a listar sus cuentas cargo
    Par_NumLis			TINYINT UNSIGNED,		-- Numero de lista que se solicita

    Par_EmpresaID       INT(11),				-- 	Auditoria
    Aud_Usuario         INT(11),				-- 	Auditoria
    Aud_FechaActual     DATETIME,				-- 	Auditoria
    Aud_DireccionIP     VARCHAR(15),			-- 	Auditoria
    Aud_ProgramaID      VARCHAR(50),			-- 	Auditoria
    Aud_Sucursal        INT(11),				-- 	Auditoria
    Aud_NumTransaccion  BIGINT(20)				-- 	Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de constantes
    DECLARE Lis_principal	INT(1);
	DECLARE Lis_filtro		INT(1);
    DECLARE Lis_WS			INT(1);

    /* Asignacion de Constantes */
    SET Lis_principal	:= 1;					-- Lista todas las cuentas cargo del usuario
    SET Lis_filtro		:= 2;					-- Lista las cuentas cargo en base a un parametro
    SET Lis_WS			:= 3;					-- Lista cuentas cargo para WS

    IF(Par_NumLis = Lis_principal) THEN
		SELECT 		bco.ClienteID,  	bco.CuentaAhoID, 	bco.Estatus, 	ca.FechaApertura, 	tc.Descripcion,
			   		s.NombreSucurs, 	ca.SaldoDispon
			   FROM BAMCUENTASORIGEN bco INNER JOIN BAMUSUARIOS  bu 	ON bco.ClienteID   	= bu.ClienteID
								         INNER JOIN  CUENTASAHO  ca  	ON bco.CuentaAhoID  = ca.CuentaAhoID
										 INNER JOIN TIPOSCUENTAS tc 	ON ca.TipoCuentaID 	= tc.TipoCuentaID
									     INNER JOIN SUCURSALES   s 	 	ON ca.SucursalID   	= s.SucursalID
										 WHERE bco.ClienteID = Par_ClienteID
										 GROUP BY bco.ClienteID, 	bco.CuentaAhoID, 	bco.Estatus, 	 ca.FechaApertura,
												  tc.Descripcion, 	s.NombreSucurs, 	ca.SaldoDispon;

	ELSEIF(Par_NumLis = Lis_filtro)THEN

		DROP TABLE IF EXISTS tabla1;
		CREATE TEMPORARY TABLE tabla1
				SELECT c.CuentaAhoID,   c.TipoCuentaID, 	t.Descripcion,	 0 AS aux
						FROM CUENTASAHO c INNER JOIN TIPOSCUENTAS t ON c.TipoCuentaID = t.TipoCuentaID
						WHERE c.ClienteID=Par_clienteID AND c.Estatus = 'A';
		UPDATE tabla1 t1   INNER JOIN  BAMCUENTASORIGEN b ON t1.CuentaAhoID = b.CuentaAhoID
		SET t1.aux = b.CuentaAhoID;
        SELECT t2.CuentaAhoID, t2.Descripcion FROM tabla1 t2
		WHERE aux =0;

    ELSEIF(Par_NumLis = Lis_WS)THEN
			SELECT bco.ClienteID, 	bco.CuentaAhoID, 	bco.Estatus, 	ca.SaldoDispon, 	ca.TipoCuentaID,
				   tc.Descripcion
				FROM BAMCUENTASORIGEN bco INNER JOIN  BAMUSUARIOS  bu  ON bco.ClienteID   = bu.ClienteID
										  INNER JOIN  CUENTASAHO   ca  ON bco.CuentaAhoID = ca.CuentaAhoID
										  INNER JOIN  TIPOSCUENTAS tc  ON ca.TipoCuentaID = tc.TipoCuentaID
					WHERE bco.ClienteID = Par_ClienteID
					GROUP BY bco.CuentaAhoID, 	 bco.ClienteID,		bco.Estatus,
							 ca.SaldoDispon, 	ca.TipoCuentaID, 	tc.Descripcion;
   END IF;
END TerminaStore$$