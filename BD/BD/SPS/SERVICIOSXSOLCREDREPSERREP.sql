DELIMITER ;
DROP PROCEDURE IF EXISTS SERVICIOSXSOLCREDREPSERREP;

DELIMITER $$
CREATE PROCEDURE SERVICIOSXSOLCREDREPSERREP(
/* Obtiene los datos para el reporte de Servicios Adicionales */
	Par_Sucursal			INT,			# ID de la sucursal
	Par_ProducCreditoID		INT,			# producto de credito
	Par_InstitNominaID		INT,			# ID de la institucion de Nómina
	Par_ConvenioNominaID    BIGINT UNSIGNED,# Numero del Convenio de Nomina
    Par_ServicioID			INT,			# ID del Servicio
    Par_Estatus				CHAR(100),		# Estatus del Crédito (Inactivo, Autorizado, Vigente, Vencido, Castigado, Pagado y Cancelado)

	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
			)
TerminaStore: BEGIN

	-- Declaración de contantes
	DECLARE Cons_S			CHAR(1);
	DECLARE Cons_B			CHAR(1);
	DECLARE Cons_TpoCueE	CHAR(1);

	DECLARE Est_Soltero			CHAR(1);        			-- Estado Civil Soltero
	DECLARE Est_CasBieSep   	CHAR(2);       				-- Casado Bienes Separados
	DECLARE Est_CasBieMan   	CHAR(2);      				-- Casado Bienes Mancomunados
	DECLARE Est_CasCapitu   	CHAR(2);       				-- Casado Bienes Mancomunados Con Capitulacion
	DECLARE Est_Viudo       	CHAR(1);        			-- Viudo
	DECLARE Est_Divorciad   	CHAR(1);        			-- Divorciado
	DECLARE Est_Seperados   	CHAR(2);       				-- Separado
	DECLARE Est_UnionLibre  	CHAR(1);        			-- Union Libre
	DECLARE Des_Soltero     	VARCHAR(100);				-- Descripcion SOLTERO
	DECLARE Des_CasBieSep   	VARCHAR(100);				-- Descripcion CASADO(A) BIENES SEPARADOS
	DECLARE Des_CasBieMan   	VARCHAR(100);				-- Descripcion CASADO(A) BIENES MANCOMUNADOS
	DECLARE Des_CasCapitu   	VARCHAR(100);				-- Descripcion CASADO(A) BIENES MANCOMUNADOS CON CAPITULACION
	DECLARE Des_Viudo       	VARCHAR(100);				-- Descripcion VIUDO
	DECLARE Des_Divorciad   	VARCHAR(100);				-- Descripcion DIVORCIADO
	DECLARE Des_Seperados   	VARCHAR(100);				-- Descripcion SEPARADO
	DECLARE Des_UnionLibre  	VARCHAR(100);				-- Descripcion UNION LIBRE

	-- Inicialización de constantes y variables
	SET Cons_S			:= 'S';	-- Contante con valor S
	SET Cons_B 			:= 'B';	-- Contante con valor b
	SET Cons_TpoCueE	:= 'E'; -- Constante para tipo de cueta = E

	SET Est_Soltero     		:= 'S';
	SET Est_CasBieSep   		:= 'CS';
	SET Est_CasBieMan   		:= 'CM';
	SET Est_CasCapitu   		:= 'CC';
	SET Est_Viudo       		:= 'V';
	SET Est_Divorciad   		:= 'D';
	SET Est_Seperados   		:= 'SE';
	SET Est_UnionLibre  		:= 'U';
	SET Des_Soltero     		:= 'SOLTERO(A)';
	SET Des_CasBieSep   		:= 'CASADO(A) BIENES SEPARADOS';
	SET Des_CasBieMan   		:= 'CASADO(A) BIENES MANCOMUNADOS';
	SET Des_CasCapitu   		:= 'CASADO(A) BIENES MANCOMUNADOS CON CAPITULACION';
	SET Des_Viudo       		:= 'VIUDO(A)';
	SET Des_Divorciad   		:= 'DIVORCIADO(A)';
	SET Des_Seperados   		:= 'SEPARADO(A)';
	SET Des_UnionLibre  		:= 'UNION LIBRE';

 	DROP TABLE IF EXISTS temp;
	CREATE TEMPORARY TABLE temp (val CHAR(255));

	IF (Par_Estatus = '') THEN
		INSERt INTO temp (val)
        SELECT DISTINCT Estatus FROM SOLICITUDCREDITO WHERE ESTATUS IS NOT NULL;
	ELSE
		SET @S1 = CONCAT("INSERT INTO temp (val) VALUES ('",REPLACE(Par_Estatus, ",", "'),('"),"');");
		PREPARE stmt1 FROM @s1;
		EXECUTE stmt1;
    END IF;


	SELECT SAxSC.CreditoID				AS CreditoID,
			SAxSC.ServicioID			AS ServicioID,
			SA.Descripcion				AS Descripcion,
			IFNULL(NOM.NombreInstit,'')	AS NombreInstit,
			IFNULL(CONV.Descripcion,'')	AS DescripcionConvenio,
			SOL.ClienteID				AS ClienteID,
			CLI.NombreCompleto			AS NombreCompleto,
			PRO.Descripcion				AS NombreProducto,
			SUC.NombreSucurs			AS Sucursal,
			CLI.Sexo					AS Genero,
			CLI.RFC						AS RFC,
			CASE CLI.EstadoCivil
			WHEN Est_Soltero	THEN	Des_Soltero
			WHEN Est_CasBieSep	THEN	Des_CasBieSep
			WHEN Est_CasBieMan	THEN	Des_CasBieMan
			WHEN Est_CasCapitu	THEN	Des_CasCapitu
			WHEN Est_Viudo		THEN	Des_Viudo
			WHEN Est_Divorciad	THEN	Des_Divorciad
			WHEN Est_Seperados	THEN	Des_Seperados
			WHEN Est_UnionLibre	THEN	Des_UnionLibre
            END
			AS EstadoCivil,
			CLI.TipoPersona				AS TipoPersona,
			DIR.DireccionCompleta		AS DireccionCompleta,
			CTRA.Clabe					AS CuentaCLABE,
			CTRA.CuentaDestino			AS Tarjeta
            ,SOL.Estatus

	  FROM SERVICIOSXSOLCRED			AS SAxSC
	 INNER JOIN SERVICIOSADICIONALES	AS SA	ON SAxSC.ServicioID = SA.ServicioID
     INNER JOIN SOLICITUDCREDITO		AS SOL	ON SAxSC.SolicitudCreditoID = SOL.SolicitudCreditoID AND SOL.AplicaDescServicio = Cons_S
	  LEFT JOIN INSTITNOMINA			AS NOM	ON SOL.InstitucionNominaID = NOM.InstitNominaID
	  LEFT JOIN CONVENIOSNOMINA			AS CONV	ON SOL.ConvenioNominaID = CONV.ConvenioNominaID
	 INNER JOIN CLIENTES				AS CLI	ON SOL.ClienteID = CLI.ClienteID
	 INNER JOIN PRODUCTOSCREDITO		AS PRO	ON SOL.ProductoCreditoID = PRO.ProducCreditoID
	 INNER JOIN SUCURSALES				AS SUC	ON SOL.SucursalID = SUC.SucursalID
	 INNER JOIN DIRECCLIENTE			AS DIR	ON CLI.ClienteID = DIR.ClienteID AND DIR.Oficial = Cons_S
	 INNER JOIN CUENTASTRANSFER			AS CTRA	ON SOL.ClienteID = CTRA.ClienteID AND CTRA.EsPrincipal = Cons_S AND CTRA.Estatus <> Cons_B  AND CTRA.TipoCuenta = Cons_TpoCueE
     WHERE SOL.SucursalID						= IF(Par_Sucursal			= 0, SOL.SucursalID, Par_Sucursal)
       AND SOL.ProductoCreditoID				= IF(Par_ProducCreditoID	= 0, SOL.ProductoCreditoID, Par_ProducCreditoID)
       AND IFNULL(SOL.InstitucionNominaID,0)	= IF(Par_InstitNominaID		= 0, IFNULL(SOL.InstitucionNominaID,0), Par_InstitNominaID)
	   AND IFNULL(SOL.ConvenioNominaID,0)		= IF(Par_ConvenioNominaID	= 0, IFNULL(SOL.ConvenioNominaID,0), Par_ConvenioNominaID)
       AND SAxSC.ServicioID						= IF(Par_ServicioID			= 0, SAxSC.ServicioID, Par_ServicioID)
       AND SOL.Estatus						   IN (SELECT val FROM temp)
;

END TerminaStore$$
DELIMITER ;
