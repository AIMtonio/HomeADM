-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASTRANSFERLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASTRANSFERLIS`;
DELIMITER $$

CREATE PROCEDURE `CUENTASTRANSFERLIS`(
# ====================================================================
# ------- STORE PARA CONSULTAR LAS CUENTAS TRANSFER---------
# ====================================================================
	Par_ClienteID		INT(11),				-- Para metro para el ID del cliente
	Par_NombreCompleto	VARCHAR(100),			-- Parametro nombre completo para filtrar las busquedas en la cuenta destino
    Par_NumLis			TINYINT UNSIGNED,		-- Parametro apra el numero de lista

    -- Parametros de auditoria
	Par_EmpresaID		INT(11) ,
	Aud_Usuario			INT(11) ,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11) ,
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Cadena_Vacia      	CHAR(1);
	DECLARE Entero_Cero        	INT(11);
	DECLARE Fecha_Vacia         DATE;
	Declare Lis_Principal		INT(11);
	DECLARE Lis_Internas        INT(11);
	DECLARE Lis_Combo           INT(11);
	DECLARE Lis_Spei    		INT(11);
	DECLARE Lis_Externas        INT(11);
	DECLARE Lis_ExternasWS		INT(11);
    DECLARE Lis_ExternasAP		INT(11);
	DECLARE Lis_SolAfilia		INT(11);
	DECLARE Lis_AfiliaNOAfilia	INT(11);
	DECLARE Esta_Activa			CHAR(1);
	DECLARE TipoInterna			CHAR(1);
	DECLARE TipoExterna			CHAR(1);
    DECLARE AplicaCredito		CHAR(1);
    DECLARE AplicaAmbas			CHAR(1);
    DECLARE Est_Afiliada		CHAR(1);
    DECLARE Est_Procesada		CHAR(1);
    DECLARE Est_NOAfiliada		CHAR(1);
    
    -- Asignacion de constantes
	SET Cadena_Vacia		:= '';				-- cadena vacia
	SET Fecha_Vacia    		:= '1900-01-01';	-- fecha vacia
	SET Entero_Cero        	:= 0;				-- entero cero
	SET	Lis_Principal		:= 1;				-- indica mostrar la lista principal
	SET Lis_Internas        := 2;				-- Listas Internas --
	SET Lis_Combo           := 3;				-- Lista combo --
	SET Lis_Spei			:= 4;				-- Lista Spei --
	SET Lis_Externas        := 5;               -- Lista Externas --
	SET Lis_ExternasWS		:= 6;				-- Lista Externas ws
	SET Lis_ExternasAP		:= 7;				-- Aportaciones
    SET Lis_SolAfilia		:= 8;				-- Lista Externa que muetra las cuentas segun la afiliacion y si es de credito o ambas.
	SET Lis_AfiliaNOAfilia	:= 9;				-- Lista de Cuentas Clabe con Estatus de Domiciliacion: Afiliada y No Afiliada
	SET Esta_Activa			:= 'A';				-- Estatus Acitiva --
	SET TipoInterna			:= 'I';				-- Tipo de cuenta Interna --
	SET TipoExterna			:= 'E';				-- Tipo de cuenta externa --
    SET AplicaCredito		:= 'C';				-- Aplica para Creditos
	SET AplicaAmbas			:= 'A';				-- Aplica para Ambas
	SET Est_Afiliada		:= 'A';				-- Estatus de Domiciliacion: Afiliada
    SET Est_Procesada		:= 'P';				-- Estatus de Domiciliacion: Procesada
    SET Est_NOAfiliada		:= 'N';				-- Estatus de Domiciliacion: No Afiliada



	-- lista todas las cuentas clabe que correspondan al cliente especificado,
	-- muestra el nombre de la institucion y la cuenta clabe.
	IF(Par_NumLis = Lis_Principal ) THEN
		SELECT	CuentaTranID,Alias,	Nombre,	Clabe
			FROM	CUENTASTRANSFER CT,	INSTITUCIONES IT
				WHERE	IT.InstitucionID	= CT.InstitucionID
				  AND 	CT.ClienteID 		= Par_ClienteID
				  AND	CT.TipoCuenta 		= TipoExterna
				  AND	CT.Estatus  		= Esta_Activa;
	END IF;

	IF(Par_NumLis = Lis_Internas ) THEN
		SELECT	CT.CuentaTranID,CT.CuentaDestino AS CuentaAhoID , CTE.NombreCompleto
			FROM    CUENTASTRANSFER CT,	CLIENTES CTE
				WHERE   CT.ClienteID	= Par_ClienteID
				  AND   CT.TipoCuenta   = TipoInterna
				  AND   CT.Estatus		= Esta_Activa
				  AND   CTE.ClienteID   = CT.ClienteDestino;
	END IF;

	IF(Par_NumLis = Lis_Combo ) THEN
		SELECT CT.CuentaDestino,CONCAT(CONVERT(CT.CuentaDestino,CHAR)," - ",CTE.NombreCompleto," - ",CUE.Etiqueta )
			FROM    CUENTASTRANSFER CT,	CLIENTES CTE,	CUENTASAHO CUE
				WHERE   CT.ClienteID	=Par_ClienteID
				  AND	CT.TipoCuenta	= TipoInterna
				  AND   CT.Estatus  	= Esta_Activa
				  AND   CTE.ClienteID 	= CT.ClienteDestino
				  AND   CUE.ClienteID 	= CT.ClienteDestino
				  AND   CUE.CuentaAhoID = CT.CuentaDestino
				  AND   CTE.Estatus 	= Esta_Activa;
	END IF;

	IF(Par_NumLis = Lis_Spei ) THEN
		SELECT	CuentaTranID,	Alias,	Descripcion AS Nombre,	Clabe
			FROM    CUENTASTRANSFER CT,	INSTITUCIONESSPEI ISP
				WHERE   ISP.InstitucionID 	= CT.InstitucionID
				  AND  	CT.ClienteID 		= Par_ClienteID
				  AND	CT.TipoCuenta 		= TipoExterna
				  AND  	CT.Estatus  		= Esta_Activa
				  AND 	(CT.Beneficiario LIKE CONCAT('%',Par_NombreCompleto,'%')
				  OR 	CT.Alias LIKE CONCAT('%',Par_NombreCompleto,'%'));
	END IF;

	IF(Par_NumLis = Lis_Externas )	THEN
		SELECT	CuentaTranID,	Alias,	Nombre,	Clabe
			FROM CUENTASTRANSFER CT,	INSTITUCIONES IT
				WHERE   IT.ClaveParticipaSpei 	= CT.InstitucionID
				  AND	CT.ClienteID 			= Par_ClienteID
				  AND	CT.TipoCuenta 			= TipoExterna
				  AND	CT.Estatus  			= Esta_Activa;
	END IF;

	IF(Par_NumLis = Lis_ExternasWS ) THEN
		SELECT	CT.CuentaTranID,	CT.Alias,	CT.Beneficiario,	CT.RFCBeneficiario,	CT.TipoCuentaSpei,
				CT.Clabe,			ISP.Descripcion AS NombreInsti,	CT.InstitucionID
			FROM CUENTASTRANSFER CT,	INSTITUCIONESSPEI ISP
				WHERE   ISP.InstitucionID 	= CT.InstitucionID
				  AND	CT.ClienteID 		= Par_ClienteID
				  AND	CT.TipoCuenta 		= TipoExterna
				  AND	CT.Estatus  		= Esta_Activa;
	END IF;
    
    IF(Par_NumLis = Lis_ExternasAP )	THEN
		SELECT	CuentaTranID,	Alias,	Nombre,	Clabe
			FROM CUENTASTRANSFER CT,	INSTITUCIONES IT
				WHERE   IT.ClaveParticipaSpei 	= CT.InstitucionID
				  AND	CT.ClienteID 			= Par_ClienteID 
				  AND	CT.TipoCuenta 			= TipoExterna
				  AND	CT.Estatus  			= Esta_Activa;
	END IF;

	-- 8.- lista todas las cuentas clabe que correspondan al cliente especificado
	IF(Par_NumLis = Lis_SolAfilia ) THEN
		SELECT	CuentaTranID,Alias,	NombreCorto AS Nombre,	Clabe
			FROM	CUENTASTRANSFER CT,	INSTITUCIONES IT
				WHERE	IT.ClaveParticipaSpei	= CT.InstitucionID
				  AND 	CT.ClienteID 		= Par_ClienteID
				  AND	CT.TipoCuenta 		= TipoExterna
                  AND	CT.AplicaPara		IN(AplicaCredito,AplicaAmbas)
                  AND	CT.EstatusDomici	IN(Est_Afiliada,Est_NOAfiliada,Est_Procesada)
				  AND	CT.Estatus  		= Esta_Activa;
	END IF;

    -- 9.-  Lista de Cuentas Clabe con Estatus de Domiciliacion: Afiliada y No Afiliada
    IF(Par_NumLis = Lis_AfiliaNOAfilia) THEN
		SELECT	CT.Clabe,	CT.EstatusDomici AS EstatusDomicilio
		FROM	CUENTASTRANSFER CT,
				INSTITUCIONES IT
		WHERE	IT.ClaveParticipaSpei	= CT.InstitucionID
		  AND 	CT.ClienteID 		= Par_ClienteID
		  AND	CT.TipoCuenta 		= TipoExterna
		  AND	CT.AplicaPara		IN(AplicaCredito,AplicaAmbas)
		  AND	CT.EstatusDomici	IN(Est_Afiliada,Est_NOAfiliada)
		  AND	CT.Estatus  		= Esta_Activa;
	END IF;
    
END TerminaStore$$