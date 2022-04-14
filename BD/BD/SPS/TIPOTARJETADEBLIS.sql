-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOTARJETADEBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOTARJETADEBLIS`;
DELIMITER $$

CREATE PROCEDURE `TIPOTARJETADEBLIS`(
-- SP PARA LISTAR EL TIPO DE TARJETA
	Par_Tipotarjeta     CHAR(1),			-- Parametro de Tipo Tarjeta
    Par_Descripcion     VARCHAR(150),		-- Parametro de Descripcion
    Par_CuentaAhoID     BIGINT(12),			-- Parametro de Cuenta de Ahorro ID
    Par_NumLis          TINYINT UNSIGNED,	-- Parametro de numero lists

    Par_EmpresaID       INT(11),			-- Parametro de Auditoria
    Aud_Usuario         INT(11),			-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal        INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)			-- Parametro de Auditoria

)
TerminaStore:BEGIN
-- DECLARACION DE VARIABLES
DECLARE Var_TipoCuenta  	INT(11);		-- Variable de Tipo cuenta
-- Declaracion de Constantes
DECLARE Lis_Principal   	INT(11);		-- Lista Principal
DECLARE Lis_Foranea     	INT(11);		-- Lista Foranea
DECLARE Entero_Cero    		INT(11);		-- Entero Cero
DECLARE Cadena_Vacia    	CHAR(1);		-- cadena Vacia
DECLARE Est_Activo     		CHAR(1);		-- Estatus Activo
DECLARE Lis_TipoTarTipoCta  INT(11);		-- Lista de tipo Tarjeta Tipo cuenta
DECLARE Lis_TipoTarDebito   INT(11);		-- Lista tipo tarjeta debito
DECLARE Lis_ComboActivos	INT(11);		-- Lista de Combos Activos
DECLARE Lis_ComboTarCobro   INT(11);		-- Lista Combos Tarjeta Cobro
DECLARE Lis_ColorTarjetas   INT(11);		-- Lista Color tarjetas
DECLARE IdentSocio	        CHAR(1);		-- Identificacion del Socio
DECLARE EstatusD	        CHAR(1);		-- Estatus Debito
DECLARE EstatusC	        CHAR(1);		-- Estatus Credito
DECLARE TipoCred			VARCHAR(8);		-- Tipo Credito
DECLARE TipoDeb				VARCHAR(7);		-- Tipo Debito
DECLARE Var_CliProEsp       INT(11);        -- Almacena el Numero de Cliente Especificos
DECLARE Con_CliProcEspe     VARCHAR(20);
DECLARE NumClienteCopayment INT(11);        -- Número de cliente especifico de copayment

-- Asiganacion de Constantes
SET Entero_Cero         := 0;	-- ENTERO En cero
SET Cadena_Vacia        := '';	-- cadena vacia
SET Lis_Principal       := 1;    -- actualizacion para asociar una tarjeta a una cuentacte
SET Lis_Foranea         := 2;    --
SET Lis_TipoTarTipoCta  := 3;    -- filtra por el tipo de cuenta que recibe.
SET Lis_TipoTarDebito   := 4;
SET Lis_ComboActivos	:= 5;	 -- Filtra solo tarjetas activas para Combo
SET Lis_ComboTarCobro	:= 6;	 -- Filtra tipo de tarjetas que no sean de identificacion para el combo
SET Lis_ColorTarjetas	:= 7;	 -- Filtra color de tarjetas  para el combo
SET Est_Activo          := 'A';  -- indica el estatus activo del tipo de tarjeta de debito
SET IdentSocio          := 'S';  -- Indica que el tipo de tarjeta es de identificacion de socio
SET EstatusD			:= 'D';
SET EstatusC			:= 'C';
SET TipoCred			:= 'CREDITO';
SET TipoDeb				:= 'DEBITO';
SET Con_CliProcEspe     := 'CliProcEspecifico'; -- Parametro de Cliente para Procesos Especificos
SET NumClienteCopayment := 34;

SET Aud_FechaActual := NOW();

    /* Muestra una lista de los tipos de tarjetas activas */
    IF(Par_NumLis = Lis_Principal) THEN
        SELECT  TipoTarjetaDebID, Descripcion,
				CASE WHEN TipoTarjeta = EstatusD THEN TipoDeb
					 WHEN TipoTarjeta = EstatusC THEN  TipoCred
				ELSE Cadena_Vacia END AS TipoTarjeta
		FROM TIPOTARJETADEB
	   WHERE Descripcion LIKE CONCAT("%", Par_Descripcion, "%") AND Estatus = Est_Activo;
    END IF;

    /* Muestra una lista de los tipos de tarjetas que existan filtrando por la descripcion */
    IF(Par_NumLis = Lis_Foranea) THEN
        SELECT TipoTarjetaDebID, Descripcion
            FROM TIPOTARJETADEB
            WHERE Descripcion LIKE CONCAT("%", Par_Descripcion, "%") AND Estatus = Est_Activo;
    END IF;

    /* Muestra una lista de los tipos de tarjetas Relacionados conel Tipo de Cuenta que se Reciba*/
    IF(Par_NumLis = Lis_TipoTarTipoCta) THEN
        SELECT TipoCuentaID INTO Var_TipoCuenta
            FROM CUENTASAHO
            WHERE cuentaAhoID = Par_CuentaAhoID;

        SELECT TD.TipoTarjetaDebID, TD.Descripcion
            FROM TIPOTARJETADEB TD
            INNER JOIN TIPOSCUENTATARDEB Tct ON Tct.TipoTarjetaDebID=TD.TipoTarjetaDebID
            WHERE Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
                AND Estatus = Est_Activo
                AND Tct.TipoCuentaID = Var_TipoCuenta
				AND TD.IdentificacionSocio != IdentSocio;
    END IF;

    IF(Par_NumLis = Lis_TipoTarDebito) THEN
        SELECT TipoTarjetaDebID, Descripcion,  CASE WHEN TipoTarjeta = EstatusD THEN TipoDeb
													WHEN TipoTarjeta = EstatusC THEN TipoCred
												ELSE Cadena_Vacia END AS TipoTarjeta
            FROM TIPOTARJETADEB
            WHERE Estatus = Est_Activo
				AND (TipoTarjetaDebID LIKE CONCAT("%", Par_Descripcion, "%")
				OR Descripcion LIKE CONCAT("%",Par_Descripcion, "%"))
				AND IdentificacionSocio != IdentSocio
		LIMIT 0,15;
    END IF;

	IF(Par_NumLis = Lis_ComboActivos) THEN

        SET Var_CliProEsp := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);
        SET Var_CliProEsp := IFNULL(Var_CliProEsp,Entero_Cero);

        IF (Var_CliProEsp = NumClienteCopayment) THEN

            SELECT TipoTarjetaDebID, Descripcion,TipoTarjeta
            FROM TIPOTARJETADEB
            WHERE Estatus = Est_Activo;

            ELSE

                SELECT TipoTarjetaDebID, Descripcion,TipoTarjeta
                FROM TIPOTARJETADEB
                WHERE Estatus = Est_Activo AND TipoTarjeta=Par_Tipotarjeta;

        END IF;


    END IF;

-- Filtra tipo de tarjetas que no sean de identificacion
	IF(Par_NumLis = Lis_ComboTarCobro) THEN
		SELECT TipoTarjetaDebID, Descripcion
            FROM TIPOTARJETADEB
			WHERE Estatus = Est_Activo
		AND IdentificacionSocio != IdentSocio;
    END IF;
    -- Colores de Tarejetas
    IF(Par_NumLis = Lis_ColorTarjetas) THEN
		SELECT ColorTarjeta, Descripcion
            FROM COLORTARJETAS;
    END IF;

END TerminaStore$$
