-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROVEEDORESMASIVOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROVEEDORESMASIVOSPRO`;

DELIMITER $$
CREATE PROCEDURE `PROVEEDORESMASIVOSPRO`(
	# =====================================================================================
	# SP PARA EL ALTA DE PROVEEDORES MASIVOS
	# =====================================================================================
    Par_FolioCargaID	    INT(11),			-- PROVEDOR

    Par_Salida              CHAR(1),			-- SALIDA
    INOUT Par_NumErr        INT(11),			-- NUMERO DE ERROR
    INOUT Par_ErrMen        VARCHAR(400),		-- MENSAJE DE ERROR

    Aud_EmpresaID           INT(11),			-- AUDITORIA
    Aud_Usuario             INT(11),			-- AUDITORIA
    Aud_FechaActual         DATETIME,			-- AUDITORIA
    Aud_DireccionIP         VARCHAR(15),		-- AUDITORIA
    Aud_ProgramaID          VARCHAR(50),		-- AUDITORIA
    Aud_Sucursal            INT(11),			-- AUDITORIA
    Aud_NumTransaccion      BIGINT(20)			-- AUDITORIA
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control         VARCHAR(100);
	DECLARE Var_Consecutivo     INT(11);
	DECLARE Var_ValorMaximo     INT(11);
    DECLARE Var_Nombre			VARCHAR(50);
    DECLARE Var_SegNombre		VARCHAR(50);
	DECLARE Var_ApellidoPaterno	VARCHAR(50);
	DECLARE Var_ApellidoMaterno	VARCHAR(50);
	DECLARE Var_RazonSocial		VARCHAR(150);
	DECLARE Var_RFC				VARCHAR(13);
	DECLARE Var_RFCM			VARCHAR(13);
	DECLARE Var_RFCOrg			VARCHAR(13);
	DECLARE Var_TipoPersona		CHAR(1);
	DECLARE Var_FechaNacimiento	DATE;
	DECLARE Var_TipoProveedor	INT(11);
	DECLARE Var_CtaContableProv	VARCHAR(25);
	DECLARE Var_CtaContableAnt	VARCHAR(25);
	DECLARE Var_Exito			INT(11);
	DECLARE Var_Fallidos		INT(11);
	DECLARE Var_NombreCompleto	VARCHAR(1500);


	-- Declaracion de constantes
	DECLARE Entero_Cero         INT(11);
	DECLARE Decimal_Cero        DECIMAL(12,2);
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE SalidaNO            CHAR(1);
	DECLARE SalidaSI            CHAR(1);


	-- Asignacion de constantes
	SET Entero_Cero         := 0;
	SET Decimal_Cero        := 0.0;
	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET SalidaNO            := 'N';
	SET SalidaSI            := 'S';
	SET Var_Exito 			:= Entero_Cero;
	SET Var_Fallidos		:= Entero_Cero;

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-PROVEEDORESMASIVOSPRO');
					SET Var_Control = 'SQLEXCEPTION' ;

		END;

    DELETE FROM TMPPROVEEDORES WHERE FolioCarga=Par_FolioCargaID;

	SET Var_Consecutivo := 1;
	SET @CON:=0;
	 INSERT TMPPROVEEDORES
		 SELECT @CON:=@CON+1 AS Consecutivo,
			Par_FolioCargaID,
			FNSEPARANOMCLIENTE(MIN(NombreEmisor),6, "NA") AS Nombre,
			FNSEPARANOMCLIENTE(MIN(NombreEmisor),1,"NA") AS ApellidoPaterno,
			SUBSTRING(MIN(NombreEmisor), 1, 150) AS RazonSocial,
			RfcEmisor,
			CASE LENGTH(RfcEmisor) WHEN 12 THEN "M" ELSE "F" END AS TipoPersona,
			CASE LENGTH(RfcEmisor) WHEN 12 THEN STR_TO_DATE(SUBSTRING(RfcEmisor,4,6),'%y%m%d')
				 ELSE STR_TO_DATE(SUBSTRING(RfcEmisor,5,6),'%y%m%d') END AS FechaNacimiento,
			TRIM(MIN(NombreEmisor)) AS NombreCompleto
		FROM BITACORACARGAFACT
		WHERE FolioCargaID=Par_FolioCargaID
		AND TipoError=3
        GROUP BY RfcEmisor;

	SET Var_ValorMaximo := (SELECT MAX(Consecutivo) FROM TMPPROVEEDORES WHERE FolioCarga=Par_FolioCargaID);
    SET Var_ValorMaximo := IFNULL(Var_ValorMaximo, 0);


    SELECT ValorParametro INTO Var_CtaContableProv
		FROM PARAMGENERALES
		WHERE LlaveParametro="CtaContableFacturasMasivas";

	SELECT ValorParametro INTO Var_CtaContableAnt
		FROM PARAMGENERALES
		WHERE LlaveParametro="CtaContaAntFacturasMasivas";

    SELECT ValorParametro INTO Var_TipoProveedor
		FROM PARAMGENERALES
		WHERE LlaveParametro="TipoProveedorFacturasMasivas";

	SET Var_TipoProveedor := IFNULL(Var_TipoProveedor, Entero_Cero);
	SET Var_CtaContableProv := IFNULL(Var_CtaContableProv, Cadena_Vacia);
	SET Var_CtaContableAnt := IFNULL(Var_CtaContableAnt, Cadena_Vacia);

    WHILE Var_Consecutivo<= Var_ValorMaximo DO
		SELECT 	NombreCompleto,				RazonSocial,				RFC,				TipoPersona,
				FechaNacimiento
         INTO   Var_NombreCompleto,			Var_RazonSocial,			Var_RFC,			Var_TipoPersona,
				Var_FechaNacimiento
		FROM TMPPROVEEDORES
        WHERE FolioCarga=Par_FolioCargaID
        AND Consecutivo=Var_Consecutivo;

        SET Var_NombreCompleto := IFNULL(Var_NombreCompleto,Cadena_Vacia);

        CALL SEPARANOMBREPRO(Var_NombreCompleto,	Var_Nombre,				Var_SegNombre,			Var_ApellidoPaterno, 		Var_ApellidoMaterno,
							SalidaNO,				Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,				Aud_Usuario,
                            Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

        SET Var_Nombre := IFNULL(Var_Nombre,Cadena_Vacia);
        SET Var_SegNombre := IFNULL(Var_SegNombre,Cadena_Vacia);
		SET Var_ApellidoPaterno := IFNULL(Var_ApellidoPaterno,Cadena_Vacia);
		SET Var_RazonSocial := IFNULL(Var_RazonSocial,Cadena_Vacia);
		SET Var_RFC := IFNULL(Var_RFC,Cadena_Vacia);
		SET Var_TipoPersona := IFNULL(Var_TipoPersona,Cadena_Vacia);
		SET Var_FechaNacimiento := IFNULL(Var_FechaNacimiento,Fecha_Vacia);
		SET Var_RFCOrg:= Var_RFC;
        IF(Var_TipoPersona="M")THEN
			SET Var_RFCM:=Var_RFC;
            SET Var_RFC :=Cadena_Vacia;
        END IF;



        CALL PROVEEDORESALT(1,							Var_ApellidoPaterno,	Cadena_Vacia,				Var_Nombre,					Cadena_Vacia,
							Var_TipoPersona,			Var_FechaNacimiento,	Cadena_Vacia,				Var_RazonSocial,			Var_RFC,
                            Var_RFCM,					Cadena_Vacia,			Cadena_Vacia,				Var_CtaContableProv,		Var_CtaContableAnt,
                            Var_TipoProveedor,			Cadena_Vacia,			Cadena_Vacia,				Cadena_Vacia,				Cadena_Vacia,
                            Cadena_Vacia,				Cadena_Vacia,			Cadena_Vacia,				Cadena_Vacia,				Cadena_Vacia,
							700,						NULL,					SalidaNO,					Par_NumErr,					Par_ErrMen,
                            Aud_EmpresaID,				Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,
							Aud_Sucursal,				Aud_NumTransaccion);

        IF(Par_NumErr<>Entero_Cero)THEN
			SET Var_Fallidos :=Var_Fallidos+1;
            UPDATE BITACORACARGAFACT SET
				DescripcionError = Par_ErrMen
			WHERE FolioCargaID = Par_FolioCargaID
				AND RfcEmisor = Var_RFCOrg;
		ELSE
			SET Var_Exito := Var_Exito +1;
        END IF;
        SET Var_Consecutivo:=Var_Consecutivo+1;
    END WHILE;

    DELETE FROM TMPPROVEEDORES WHERE FolioCarga=Par_FolioCargaID;

    SET Par_NumErr := 000;
    SET Par_ErrMen := CONCAT("Registros de proveedores <br>No. Proveedores cargados exitosamente: ",Var_Exito,"<br>No. Proveedores Cargados Con Falla: ",Var_Fallidos);

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT Par_NumErr AS NumErr,
           Par_ErrMen AS ErrMen,
           Var_Control AS control,
           Var_Exito AS Exito,
           Var_Fallidos AS Fallidos;
END IF;
END TerminaStore$$