-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCDETMOVEXGRALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATDCDETMOVEXGRALPRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTATDCDETMOVEXGRALPRO`(
		-- Estado de Cuenta de Tarjeta de Credito Detalle de Movimientos general de moneda extrangera
        Par_DiaCorte				INT,			         -- Dia del corte del targeta de credito
        Par_Periodo					INT,			         -- Periodo de l targeta de credito
        Par_FecIniCorte				DATE,			         -- Fecha de inicio del corte
        Par_FecFinCorte				DATE,			         -- Fecha final del corte
        Par_EmpresaID				INT,			         -- Parametro de auditoria
        Aud_Usuario					INT,			         -- Parametro de auditoria
        Aud_FechaActual				DATETIME,		         -- Parametro de auditoria
        Aud_DireccionIP				VARCHAR(15),	         -- Parametro de auditoria
        Aud_ProgramaID				VARCHAR(50),	         -- Parametro de auditoria
        Aud_Sucursal				INT,			         -- Parametro de auditoria
        Aud_NumTransaccion	        BIGINT)
TerminaStore: BEGIN

		-- Declaraciones de Constantes
        DECLARE	Entero_Cero				INT;		         -- Entero cero
        DECLARE	Cadena_Vacia			CHAR(1);	         -- Cadena Vacial
        DECLARE	Cadena_Espacio			CHAR(3);	         -- Cadena de espacio
        DECLARE	TipoTarCre 				CHAR(1);	         -- Tipo de Targeta de credito
        DECLARE	Fecha_Vacia				DATE;		         -- Fecha Vacia
        DECLARE	SombraSI				CHAR(1);
        DECLARE	SombraNO				CHAR(1);

		-- Declaracion de variables
        DECLARE Var_NatCargo			CHAR(1);	         -- Variable para cargo
        DECLARE Var_NatAbono			CHAR(1);	         -- Variable de abono
        DECLARE Var_CodMonExtranjero	INT;		         -- Codigo de Moneda Extrangera
        DECLARE Var_Estatus				CHAR(1);	         -- Variable de estatus				

		-- Asignacion de Constantes
        SET	Entero_Cero					:= 0;				 -- Entero cero
        SET Cadena_Vacia				:= '';				 -- Cadena Vacial
        SET Cadena_Espacio 				:= '   ';			 -- Cadena de espacio
        SET TipoTarCre					:= 'C';				 -- Tipo de Targeta de credito
        SET	Fecha_Vacia					:= '1900-01-01';	 -- Fecha Vacia
        SET SombraSI					:= 'S';
        SET SombraNO					:= 'N';

		-- Asignacion de Variable
        SET Var_NatCargo				:= 'C';		         -- Variable para cargo
        SET Var_NatAbono				:= 'A';		         -- Variable de abono
        SET Var_CodMonExtranjero		:= 840;		         -- Codigo de Moneda Extrangera
        SET Var_Estatus					:='P';		         -- Variable de estatus

	
		INSERT INTO EDOCTATDCDETMOVEXGRAL
			SELECT	Par_Periodo,		Par_DiaCorte,		Entero_Cero AS Linea,		TarjetaCredID,		FechaOperacion,		
					Referencia,
					CONCAT(NombreComercio, ' [', Ciudad,']','  \nDolar U.S.A   ',MontoOperacion, '   TC:', TipoCambio) AS Descripcion,
						CASE WHEN Naturaleza = Var_NatCargo THEN MontoOperacionMx ELSE Entero_Cero END AS Cargos,
						CASE WHEN Naturaleza = Var_NatAbono THEN MontoOperacionMx ELSE Entero_Cero END AS Abonos,
						Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
					FROM TC_BITACORAMOVS	
					WHERE FechaOperacion >= Par_FecIniCorte
						AND FechaOperacion <= Par_FecFinCorte
						AND Estatus = Var_Estatus
						AND CodigoMonOpe = Var_CodMonExtranjero;
	
	
			UPDATE EDOCTATDCDETMOVEXGRAL Mov
				INNER JOIN TARJETACREDITO Tar ON Tar.TarjetaCredID = Mov.NumTarjeta
				SET Mov.LineaTarCredID = Tar.LineaTarCredID;
		
END TerminaStore$$