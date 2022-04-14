-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBGIROSXTIPOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBGIROSXTIPOCON`;DELIMITER $$

CREATE PROCEDURE `TARDEBGIROSXTIPOCON`(
#SP PARA CONSULTA DE GIROS POR TIPO
	Par_TipoTarjetaDebID	INT(11),		-- Parametro de Tipo Tarjeta ID
    Par_NumCon              TINYINT UNSIGNED,-- Parametro de numero de consulta

    Aud_EmpresaID           INT(11),		-- Parametro de Auditoria
    Aud_Usuario             INT(11),		-- Parametro de Auditoria
    Aud_FechaActual         DATETIME,		-- Parametro de Auditoria
    Aud_DireccionIP         VARCHAR(15),	-- Parametro de Auditoria
    Aud_ProgramaID          VARCHAR(100),	-- Parametro de Auditoria
    Aud_Sucursal            INT(11),		-- Parametro de Auditoria
    Aud_NumTransaccion      BIGINT(20)		-- Parametro de Auditoria
	)
TerminaStore: BEGIN

-- Declaracion de Cosntantes
DECLARE Con_GiroTipoTarjeta	INT;
DECLARE Estatus_Activo		CHAR(1);
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE EstatusD	        CHAR(1);
DECLARE EstatusC	        CHAR(1);
DECLARE TipoCred			VARCHAR(8);
DECLARE TipoDeb				VARCHAR(7);

-- Asignacion de Constantes
SET Estatus_Activo			:='A'; 		-- Estatus Activo
SET Con_GiroTipoTarjeta		:= 2;    	-- Consulta de Giros de Negocio por Tipo de Tarjeta
SET EstatusD				:= 'D';		-- Estatus Debito
SET EstatusC				:= 'C';		-- Estatus Credito
SET TipoCred				:= 'CREDITO';	-- Leyenda Credito
SET TipoDeb					:= 'DEBITO';	-- Leyenda Debito
SET Cadena_Vacia        	:= '';			-- Cadena Vacia

    -- 2 Consulta de Giros de Negocio por Tipo de Tarjeta Activas
IF(Par_NumCon = Con_GiroTipoTarjeta) THEN
	SELECT TipoTarjetaDebID, Descripcion, IdentificacionSocio,
			CASE WHEN TipoTarjeta = EstatusD THEN TipoDeb
					 WHEN TipoTarjeta = EstatusC THEN  TipoCred
				ELSE Cadena_Vacia END AS TipoTarjeta
		FROM TIPOTARJETADEB
		WHERE TipoTarjetaDebID=	Par_TipoTarjetaDebID
			AND Estatus=Estatus_Activo;
END IF;

END TerminaStore$$