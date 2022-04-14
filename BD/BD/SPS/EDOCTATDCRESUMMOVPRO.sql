-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCRESUMMOVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATDCRESUMMOVPRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTATDCRESUMMOVPRO`(
	Par_DiaCorte 				   INT,					-- Dia del corte del un tarjeta
	Par_Periodo                    INT,					-- Periodo de inicio a fecha de corte de una tarjeta
	Par_FecFinCorte			       DATE,				-- Fecha fin corte
	Par_EmpresaID				   INT,					-- Parametro de Auditoria
	Aud_Usuario					   INT,					-- Parametro de Auditoria
	Aud_FechaActual			       DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			       VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID			       VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal				   INT,					-- Parametro de Auditoria
	Aud_NumTransaccion	           BIGINT				-- Parametro de Auditoria
)
TerminaStore: BEGIN

    -- Declaraciones de Constantes
	DECLARE	Entero_Cero				INT;
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	SombraSI				CHAR(1);
	DECLARE	SombraNO				CHAR(1);


    -- Asignacion de Constantes
	SET	Entero_Cero					:= 0;
	SET Cadena_Vacia				:= '';
	SET	Fecha_Vacia					:= '1900-01-01';
	SET SombraSI					:= 'S';
	SET SombraNO					:= 'N';

	INSERT INTO EDOCTATDCRESUMMOV
		SELECT	Par_Periodo,		Par_DiaCorte, 	LineaTarCredID,		1 AS Orden,		'SALDO INICIAL' AS Concepto,
					SaldoInicial,		SombraNO,Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
			FROM TC_PERIODOSLINEA
  	WHERE FechaCorte = Par_FecFinCorte;



	INSERT INTO EDOCTATDCRESUMMOV
		SELECT	Par_Periodo,		Par_DiaCorte, 	LineaTarCredID,		2 AS Orden,		'TOTAL DE COMPRAS(CON IVA)' AS Concepto,
					TotalCompras,		SombraNO,Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
			FROM TC_PERIODOSLINEA
  		WHERE FechaCorte = Par_FecFinCorte;


	INSERT INTO EDOCTATDCRESUMMOV
		SELECT	Par_Periodo,		Par_DiaCorte, 	LineaTarCredID,		3 AS Orden,		'INTERESES GENERADOS(CON IVA)' AS Concepto,
					TotalInteres,		SombraNO,Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
			FROM TC_PERIODOSLINEA
  		WHERE FechaCorte = Par_FecFinCorte;


	INSERT INTO EDOCTATDCRESUMMOV
		SELECT	Par_Periodo,		Par_DiaCorte, 	LineaTarCredID,		4 AS Orden,		'COMISIONES GENERADAS(CON IVA)' AS Concepto,
					TotalComisiones,		SombraNO,Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
			FROM TC_PERIODOSLINEA
	 	WHERE FechaCorte = Par_FecFinCorte;


	INSERT INTO EDOCTATDCRESUMMOV
		SELECT	Par_Periodo,		Par_DiaCorte, 	LineaTarCredID,		5 AS Orden,		'TOTAL DE CARGOS(CON IVA)' AS Concepto,
					TotalCargosPer,		SombraSI,Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
			FROM TC_PERIODOSLINEA
  	WHERE FechaCorte = Par_FecFinCorte;


	INSERT INTO EDOCTATDCRESUMMOV
		SELECT	Par_Periodo,		Par_DiaCorte, 	LineaTarCredID,		6 AS Orden,		'PAGOS REALIZADOS' AS Concepto,
					TotalPagos,		SombraNO, Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
			FROM TC_PERIODOSLINEA
  	WHERE FechaCorte = Par_FecFinCorte;




	INSERT INTO EDOCTATDCRESUMMOV
		SELECT	Par_Periodo,		Par_DiaCorte, 	LineaTarCredID,		7 AS Orden,		'SALDO AL CORTE' AS Concepto,
					SaldoCorte,		SombraNO, Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
		FROM TC_PERIODOSLINEA
 	 WHERE FechaCorte = Par_FecFinCorte;


	INSERT INTO EDOCTATDCRESUMMOV
		SELECT	Par_Periodo,		Par_DiaCorte, 	LineaTarCredID,		8 AS Orden,		'PAGO PARA NO GENERAR INTERESES' AS Concepto,
					PagoNoGenInteres,		SombraNO,   Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
			FROM TC_PERIODOSLINEA
  	WHERE FechaCorte = Par_FecFinCorte;


	INSERT INTO EDOCTATDCRESUMMOV
		SELECT	Par_Periodo,		Par_DiaCorte, 	LineaTarCredID,		9 AS Orden,		'PAGO MINIMO' AS Concepto,
					PagoMinimo,		SombraNO, Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
			FROM TC_PERIODOSLINEA
  	WHERE FechaCorte = Par_FecFinCorte;
INSERT INTO EDOCTATDCRESUMMOV
		SELECT	Par_Periodo,		Par_DiaCorte, 	LineaTarCredID,		10  AS Orden,		'SALDO A FAVOR' AS Concepto,
					SaldoAFavor,		SombraNO,    Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
			FROM TC_PERIODOSLINEA
  	WHERE FechaCorte = Par_FecFinCorte;


END TerminaStore$$