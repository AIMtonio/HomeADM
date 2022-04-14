-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASSANTANDERLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASSANTANDERLIS`;
DELIMITER $$

CREATE PROCEDURE `CUENTASSANTANDERLIS`(
-- ===================================================================================
-- SP PARA LISTAR LA CUENTAS SANTANDER
-- ===================================================================================
	Par_FechaInicio				DATE,				-- FECHA INICIO
	Par_FechaFin				DATE,				-- FECHA FINAL
	Par_TipoCta					CHAR(1),			-- Tipo de cuenta
	Par_Estatus					CHAR(1),			-- Estatus
	Par_TipoLista				TINYINT UNSIGNED,	-- Tipo de Lista

    /* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Lis_Principal			INT(11);		-- Lista las cuentas de santander
	DECLARE	Cadena_Vacia			VARCHAR(1);		-- Cadena Vacia
	DECLARE	EspacioBlanco			VARCHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero				INT(11);		-- Entero cero
	DECLARE	SalidaSI        		CHAR(1);		-- Salida Si
	DECLARE	SalidaNO        		CHAR(1);		-- Salida No

	-- Asignacion de Constantes
	SET	Lis_Principal	  			:= 1;
	SET EspacioBlanco				:= ' ';
	SET Cadena_Vacia				:= '';
	SET Fecha_Vacia					:= '1900-01-01';
	SET Entero_Cero					:= 0;
	SET	SalidaSI        			:= 'S';
	SET	SalidaNO        			:= 'N';

	SET Par_TipoLista := IFNULL(Par_TipoLista, Entero_Cero);
	
    
    -- Lista Principal
	IF(Par_TipoLista = Lis_Principal)  THEN
		SELECT 	IFNULL(TipoCtaSAFIID, Cadena_Vacia) AS TipoCtaSAFIID,
                IFNULL(Estatus,Cadena_Vacia) AS	Estatus,				
                IFNULL(DesEstatus, Cadena_Vacia) AS DesRechazo,				
                RPAD(IFNULL(TipoCuenta,  Cadena_Vacia),6, EspacioBlanco) AS TipoCuenta,
                RPAD(IFNULL(NumeroCta, Cadena_Vacia),20, EspacioBlanco) AS NumeroCta,
				RPAD(SUBSTRING(IFNULL(FNLIMPIACARACTERESGEN(REPLACE(Titular,'Ñ','N'),"OR"),	Cadena_Vacia),1,40),40, EspacioBlanco) AS Titular,
				RPAD(IFNULL(ClaveBanco, Cadena_Vacia),5,EspacioBlanco) AS ClaveBanco,
				RPAD(IFNULL(Cadena_Vacia, Cadena_Vacia),5,EspacioBlanco) AS PazaBanxico,
				RPAD(IFNULL(Cadena_Vacia,Cadena_Vacia),5,EspacioBlanco)  AS SucursalID,
				RPAD(IFNULL(40, Cadena_Vacia),2,EspacioBlanco) AS TipoCta,
                RPAD(SUBSTRING(IFNULL(FNLIMPIACARACTERESGEN(REPLACE(BenefAppPaterno,'Ñ','N'),"OR"),Cadena_Vacia),1,20),20,EspacioBlanco) AS BenefAppPaterno,		
                RPAD(SUBSTRING(IFNULL(FNLIMPIACARACTERESGEN(REPLACE(BenefAppMaterno,'Ñ','N'),"OR"),Cadena_Vacia),1,20),20,EspacioBlanco) AS BenefAppMaterno,
                RPAD(SUBSTRING(IFNULL(FNLIMPIACARACTERESGEN(REPLACE(BenefNombre,'Ñ','N'),"OR"), Cadena_Vacia),1,120),120,EspacioBlanco) AS BenefNombre,	        
                RPAD(SUBSTRING(IFNULL(replace(replace(FNLIMPIACARACTERESACENTOS(REPLACE(BenefDireccion,'Ñ','N')), ',',''),'.',''),Cadena_Vacia),1,140),140,EspacioBlanco) AS BenefDireccion,		
                RPAD(SUBSTRING(IFNULL(replace(replace(FNLIMPIACARACTERESACENTOS(REPLACE(BenefCiudad,'Ñ','N')), ',',''),'.',''),  Cadena_Vacia),1,35),35,EspacioBlanco) AS BenefCiudad
			FROM CUENTASSANTANDER
		WHERE TipoCtaSAFIID = Par_TipoCta
		AND Estatus=Par_Estatus
        AND FechaRegistro BETWEEN Par_FechaInicio AND Par_FechaFin;
	END IF;



END TerminaStore$$