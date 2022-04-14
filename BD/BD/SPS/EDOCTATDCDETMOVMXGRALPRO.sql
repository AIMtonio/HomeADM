-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCDETMOVMXGRALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATDCDETMOVMXGRALPRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTATDCDETMOVMXGRALPRO`(
		-- Estado de Cuenta de Tarjeta de Credito Detalle de Movimientos general de moneda nacional
        Par_DiaCorte				    INT,             -- Periodo de inicio a fecha de corte de una targeta de credito
        Par_Periodo					    INT,     -- Dia del corte del un tarjeta de credito
        Par_FecIniCorte				    DATE,            -- Fecha inicio corte
        Par_FecFinCorte				    DATE,            -- Fecha fin corte
        Par_EmpresaID				    INT,             -- Parametro de Auditoria
        Aud_Usuario					    INT,     -- Parametro de Auditoria
        Aud_FechaActual				    DATETIME,        -- Parametro de Auditoria
        Aud_DireccionIP				    VARCHAR(15),     -- Parametro de Auditoria
        Aud_ProgramaID				    VARCHAR(50),     -- Parametro de Auditoria
        Aud_Sucursal				    INT,             -- Parametro de Auditoria
        Aud_NumTransaccion	            BIGINT)
TerminaStore: BEGIN

		-- Declaraciones de Constantes
        DECLARE	Entero_Cero				INT;
        DECLARE	Cadena_Vacia			CHAR(1);
        DECLARE	Cadena_Espacio			CHAR(3);
        DECLARE	TipoTarCre 				CHAR(1);
        DECLARE	Fecha_Vacia				DATE;
        DECLARE	SombraSI				CHAR(1);
        DECLARE	SombraNO				CHAR(1);

		-- Declaracion de variables
        DECLARE Var_NatCargo			CHAR(1);
        DECLARE Var_NatAbono			CHAR(1);
        DECLARE Var_CodMonNacional		INT;
        DECLARE Var_Estatus				CHAR(1);

		-- Asignacion de Constantes
        SET	Entero_Cero					:= 0;
        SET Cadena_Vacia				:= '';
        SET Cadena_Espacio 				:= '   ';
        SET TipoTarCre					:= 'C';
        SET	Fecha_Vacia					:= '1900-01-01';
        SET SombraSI					:= 'S';
        SET SombraNO					:= 'N';

		-- Asignacion de Variable
        SET Var_NatCargo				:= 'C';
        SET Var_NatAbono				:= 'A';
        SET Var_CodMonNacional			:= 484;
        SET Var_Estatus					:='P';


		INSERT INTO EDOCTATDCDETMOVMXGRAL
			SELECT	Par_Periodo,		Par_DiaCorte,		Entero_Cero AS Linea,		TarjetaCredID,		FechaOperacion,
					Referencia,
					CONCAT(NombreComercio, ' [', Ciudad,']') AS Descripcion,
						CASE WHEN Naturaleza = Var_NatCargo THEN MontoOperacionMx ELSE Entero_Cero END AS Cargos,
						CASE WHEN Naturaleza = Var_NatAbono THEN MontoOperacionMx ELSE Entero_Cero END AS Abonos,
						Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
					FROM TC_BITACORAMOVS
					WHERE FechaOperacion >= Par_FecIniCorte
						AND FechaOperacion <= Par_FecFinCorte
						AND Estatus = Var_Estatus
						AND CodigoMonOpe = Var_CodMonNacional;


			UPDATE EDOCTATDCDETMOVMXGRAL Mov
				INNER JOIN TARJETACREDITO Tar ON Tar.TarjetaCredID = Mov.NumTarjeta
				SET Mov.LineaTarCredID = Tar.LineaTarCredID;

END TerminaStore$$