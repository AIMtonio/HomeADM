-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCTASASINTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATDCTASASINTPRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTATDCTASASINTPRO`(
	Par_DiaCorte 				    INT,			-- Dia del corte del un tarjeta
	Par_Periodo                     INT,			-- Periodo de inicio a fecha de corte de una tarjeta
	Par_FecFinCorte			        DATE,			-- Fecha inicio corte
	Par_EmpresaID				    INT,			-- Parametro de Auditoria
	Aud_Usuario					    INT,			-- Parametro de Auditoria
	Aud_FechaActual			        DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			        VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			        VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal				    INT,			-- Parametro de Auditoria
	Aud_NumTransaccion	            BIGINT			-- Parametro de Auditoria
)
TerminaStore: BEGIN

-- Declaraciones de Constantes
	DECLARE	Entero_Cero				INT;
	DECLARE	Decimal_Cero			DECIMAL(14,2);
	DECLARE	Cadena_Vacia			CHAR(1);
  DECLARE	Cadena_Espacio		    CHAR(3);
	DECLARE	TipoTarCre 				CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	SombraSI				CHAR(1);
	DECLARE	SombraNO				CHAR(1);


-- Asignacion de Constantes
	SET	Entero_Cero					:= 0;
	SET	Decimal_Cero				:= 0.0;
	SET Cadena_Vacia				:= '';
	SET Cadena_Espacio 			    := '   ';
	SET TipoTarCre					:= 'C';
	SET	Fecha_Vacia					:= '1900-01-01';
	SET SombraSI					:= 'S';
	SET SombraNO					:= 'N';



	INSERT INTO EDOCTATDCTASASINT
	SELECT	Par_Periodo,		Par_DiaCorte, 	EDO.LineaTarCredID,    EDO.TipoTarjetaDebID,	1 AS Orden,   'CAT Cargos Regulares (Costo Anula Total) Sin IVA' AS Concepto,
					LIN.CAT,		CASE WHEN IFNULL(LIN.CAT,Decimal_Cero) = Decimal_Cero THEN Decimal_Cero ELSE ROUND(IFNULL(LIN.CAT,Decimal_Cero)/12,2) END, 		SombraNO, Cadena_Vacia, Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
	FROM LINEATARJETACRED AS LIN
	INNER JOIN EDOCTATDCLINEACRED AS EDO ON EDO.LineaTarCredID = LIN.LineaTarCredID
	INNER JOIN TIPOTARJETADEB AS TIP ON TIP.TipoTarjetaDebID = EDO.TipoTarjetaDebID
	WHERE TIP.TipoTarjeta = TipoTarCre
	  AND TIP.IdentificacionSocio = 'N';


	INSERT INTO EDOCTATDCTASASINT
	SELECT	Par_Periodo,		Par_DiaCorte, 	LIN.LineaTarCredID,  EDO.TipoTarjetaDebID,			2 AS Orden,				'ORDINARIA' AS Concepto,
					-1,		-1, 		SombraSI, 						Cadena_Espacio,Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
	FROM LINEATARJETACRED AS LIN
	INNER JOIN EDOCTATDCLINEACRED AS EDO ON EDO.LineaTarCredID = LIN.LineaTarCredID
	INNER JOIN TIPOTARJETADEB AS TIP ON TIP.TipoTarjetaDebID = EDO.TipoTarjetaDebID
	WHERE TIP.TipoTarjeta = TipoTarCre
	  AND TIP.IdentificacionSocio = 'N';


	INSERT INTO EDOCTATDCTASASINT
	SELECT	Par_Periodo,		Par_DiaCorte, 	EDO.LineaTarCredID,	EDO.TipoTarjetaDebID,					3 AS Orden,					'TASA INTERES' AS Concepto,
					IFNULL(LIN.TasaFija,Decimal_Cero) ,		IFNULL(ROUND(LIN.TasaFija/12.00 , 2), Decimal_Cero), 		SombraNO, 				Cadena_Vacia,
					Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
	FROM LINEATARJETACRED AS LIN
	INNER JOIN EDOCTATDCLINEACRED AS EDO ON EDO.LineaTarCredID = LIN.LineaTarCredID
	INNER JOIN TIPOTARJETADEB AS TIP ON TIP.TipoTarjetaDebID = EDO.TipoTarjetaDebID
	WHERE TIP.TipoTarjeta = TipoTarCre
	  AND TIP.IdentificacionSocio = 'N';


	INSERT INTO EDOCTATDCTASASINT
	SELECT	Par_Periodo,		Par_DiaCorte, 	EDO.LineaTarCredID,  EDO.TipoTarjetaDebID,				4 AS Orden,				'TASA MORATORIA' AS Concepto,
                    CASE    WHEN LIN.CobraMora = 'S' AND LIN.TipoCobMora = 'N' THEN ROUND(IFNULL(LIN.FactorMora,Decimal_Cero) * LIN.TasaFija,2)
                            WHEN LIN.CobraMora = 'S' AND LIN.TipoCobMora = 'T' THEN LIN.TasaFija
                    ELSE Decimal_Cero END,
                    CASE    WHEN LIN.CobraMora = 'S' AND LIN.TipoCobMora = 'N' THEN ROUND((IFNULL(LIN.FactorMora,Decimal_Cero) * LIN.TasaFija) / 12,2)
                            WHEN LIN.CobraMora = 'S' AND LIN.TipoCobMora = 'T' THEN ROUND(LIN.TasaFija/12,2)
                    ELSE Decimal_Cero END,
					SombraNO,
					Cadena_Vacia,Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
	FROM LINEATARJETACRED AS LIN
	INNER JOIN EDOCTATDCLINEACRED AS EDO ON EDO.LineaTarCredID = LIN.LineaTarCredID
	INNER JOIN TIPOTARJETADEB AS TIP ON TIP.TipoTarjetaDebID = EDO.TipoTarjetaDebID
	WHERE TIP.TipoTarjeta = TipoTarCre
	  AND TIP.IdentificacionSocio = 'N';


END TerminaStore$$