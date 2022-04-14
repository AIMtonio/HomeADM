-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOSNOMINACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `FOLIOSNOMINACON`;
DELIMITER $$

CREATE PROCEDURE `FOLIOSNOMINACON`(
-- =====================================================
-- ------- STORED DE CONSULTA DE FOLIOS DE CARGA DE NOMINA ---------
-- =====================================================
    Par_EmpresaNominaID		INT(11),            -- Institucion de Nomina
    Par_FolioCargaID		INT(11),            -- Folio de Carga de Nomina
    Par_TipoCon				INT(11),            -- Tipo de Consulta 1-Princiapl

    Par_EmpresaID       	INT(11),            -- Parametros de Auditoria
    Aud_Usuario         	INT(11),            -- Parametros de Auditoria
    Aud_FechaActual     	DATETIME,           -- Parametros de Auditoria
    Aud_DireccionIP     	VARCHAR(15),        -- Parametros de Auditoria
    Aud_ProgramaID      	VARCHAR(50),        -- Parametros de Auditoria
    Aud_Sucursal        	INT(11),            -- Parametros de Auditoria
    Aud_NumTransaccion  	BIGINT(20)          -- Parametros de Auditoria
	)
TerminaStore:BEGIN

-- Declaracion de Variables
DECLARE RegPendientes   INT(11);                -- Numero de Registros Pendientes por Procesar 

-- Declaracion de Constantes
DECLARE Con_Principal   INT(11);                -- Constante Consulta Principal 1
DECLARE Cadena_Vacia    CHAR(1);                -- Constante Cadena Vacia
DECLARE	Fecha_Vacia		DATE;                   -- Constante Fecha Vacia
DECLARE Entero_Cero     INT(11);                -- Constante Entero Cero
DECLARE FechaSis        DATE;                   -- Fecha del Sistema
DECLARE Var_Procesado   CHAR(1);                -- Constante de Estatus Procesado BECARGAPAGNOMINA
DECLARE Var_PorAplicar  CHAR(11);               -- Constante de Estatus por Aplicar  BEPAGOSNOMINA

-- Seteo de Constantes
SET Con_Principal   	:= 1;
SET Cadena_Vacia		:= '';
SET	Fecha_Vacia		    := '1900-01-01';
SET Entero_Cero			:= 0;
SET Var_Procesado       := 'P';
SET Var_PorAplicar      := 'P';

SET FechaSis:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

IF(Par_TipoCon = Con_Principal)THEN
    SET RegPendientes := (SELECT COUNT(Estatus)
									 FROM BEPAGOSNOMINA
									 WHERE Estatus=Var_PorAplicar
									 AND FolioCargaID= Par_FolioCargaID);
    SET RegPendientes := IFNULL(RegPendientes, Entero_Cero);

	SELECT Car.FolioCargaID, RegPendientes, Car.Estatus, Car.FechaApliPago
		FROM BECARGAPAGNOMINA Car
		    WHERE Car.FolioCargaID= Par_FolioCargaID
                    AND Car.EmpresaNominaID=Par_EmpresaNominaID
            LIMIT 1;
END IF;


END TerminaStore$$