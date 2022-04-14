-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-CUENAHOMOVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HIS-CUENAHOMOVALT`;
DELIMITER $$


CREATE PROCEDURE `HIS-CUENAHOMOVALT`(
	-- SP que se usa en el CIERREMESAHORRO
	Par_FechaOperacion	DATE
		)

TerminaStore: BEGIN

-- Declaracion de variables
DECLARE	Var_Empresa			INT(11);
DECLARE	Aud_Usuario			INT(11);
DECLARE Aud_FechaActual		DATE;
DECLARE Aud_DireccionIP		VARCHAR(20);
DECLARE Aud_ProgramaID		VARCHAR(100);
DECLARE Aud_Sucursal		INT(11);
DECLARE Aud_NumTransaccion	BIGINT(20);

-- eclaracion de Constantes
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Entero_Cero		INT(11);
DECLARE Un_DiaHabil		INT(11);
DECLARE	Es_DiaHabil		CHAR(1);
DECLARE Var_FecSiguie	DATE;

-- Asignacion de Constantes
SET	Cadena_Vacia	:= '';						-- Cadena vacia
SET	Entero_Cero		:= 0;						-- Entero cero
SET Un_DiaHabil		:= 1;						-- Un dia habil


-- Asignacion de variables 
SET	Var_Empresa			:= 1;					-- Parametro de auditoria
SET	Aud_Usuario			:= 1;					-- Parametro de auditoria
SET Aud_FechaActual		:= NOW();				-- Parametro de auditoria
SET Aud_DireccionIP		:= '127.0.0.1';			-- Parametro de auditoria
SET Aud_ProgramaID		:= 'CIERREGENERALPRO';	-- Parametro de auditoria
SET Aud_Sucursal		:= 1;					-- Parametro de auditoria
SET Aud_NumTransaccion	:= 1;					-- Parametro de auditoria

-- INICIO- SECCION PARA VALIDAR SI LA FECHA SIGUEINTE ES DIA HABIL,
-- Y SI ES EL FINAL DEL MES CAMBIA LA FECHA DE OPERACION A LA FECHA FINAL DEL MES
 CALL DIASFESTIVOSCAL(
            Par_FechaOperacion, Un_DiaHabil,        Var_FecSiguie,      Es_DiaHabil,        Var_Empresa,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

SET	Var_FecSiguie	:= IFNULL(Var_FecSiguie,Par_FechaOperacion);

 IF(MONTH(Par_FechaOperacion) != MONTH(Var_FecSiguie))THEN
 	SET Par_FechaOperacion  := LAST_DAY(Par_FechaOperacion);
 END IF;
-- FIN SECCION VALIDA FECHA

INSERT INTO `HIS-CUENAHOMOV` (	CuentaAhoID,	NumeroMov,		Fecha,			NatMovimiento,	CantidadMov,
								DescripcionMov,	ReferenciaMov,	TipoMovAhoID,	MonedaID,		PolizaID,
                                EmpresaID,		Usuario,		FechaActual,	DireccionIP,	ProgramaID,
                                Sucursal,		NumTransaccion	)

					(SELECT 		CuentaAhoID,	NumeroMov,		Fecha,			NatMovimiento,	CantidadMov,
								DescripcionMov,	ReferenciaMov,	TipoMovAhoID,	MonedaID,		PolizaID,
                                EmpresaID,		Usuario,		FechaActual,	DireccionIP,	ProgramaID,
                                Sucursal,		NumTransaccion
					FROM 		CUENTASAHOMOV
						WHERE Fecha >= DATE_ADD(Par_FechaOperacion, INTERVAL -1*(DAY(Par_FechaOperacion))+1 DAY)
						AND Fecha <= Par_FechaOperacion)
					UNION ALL
					(SELECT 		CuentaAhoID,	NumeroMov,		Fecha,			NatMovimiento,	CantidadMov,
								DescripcionMov,	ReferenciaMov,	TipoMovAhoID,	MonedaID,		PolizaID,
								EmpresaID,		Usuario,		FechaActual,	DireccionIP,	ProgramaID,
                                Sucursal,		NumTransaccion
					FROM 		TMPCTASAHOMOV);


DELETE FROM  CUENTASAHOMOV
	WHERE Fecha >= DATE_ADD(Par_FechaOperacion, INTERVAL -1*(DAY(Par_FechaOperacion))+1 DAY)
	AND Fecha <= Par_FechaOperacion;

END TerminaStore$$