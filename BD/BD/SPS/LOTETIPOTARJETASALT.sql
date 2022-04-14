-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LOTETIPOTARJETASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `LOTETIPOTARJETASALT`;
DELIMITER $$

CREATE PROCEDURE `LOTETIPOTARJETASALT`(
-- ===================================================================================
-- SP ALTA DE LOTE DE TARJETAS Y NOMBRE DE PERSONAS SI ES PERSONALIZADA - SE OCUPA PARA CONSUMO WS
-- ===================================================================================
	Par_LoteDebitoSAFIID	INT(11),
	Par_TipoTarjetaDebID	INT(11),
  	Par_SucursalSolicita	CHAR(4),
	Par_UsuarioID			INT(11),
	Par_NumTarjetas			INT(11),

	Par_EsPersonalizado		CHAR(1),
  	Par_NomArchiGen			VARCHAR(50),
	Par_FolioInicial		INT(11),
	Par_FolioFinal			INT(11),
	Par_BitCargaID			INT(11),

	Par_ServiceCode			CHAR(3),
	Par_NombrePatroc		VARCHAR(50),
	Par_NombresPersonal     TEXT,

	Par_Salida				CHAR(1),
	INOUT Par_NumErr    	INT(11),
    INOUT Par_ErrMen    	VARCHAR(400),

    /* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia				VARCHAR(1);
	DECLARE	Fecha_Vacia					DATE;
	DECLARE	Entero_Cero					INT(11);
	DECLARE	SalidaSI 					CHAR(1);
	DECLARE	SalidaNO					CHAR(1);
	DECLARE Var_patroc					INT(11);
	DECLARE Var_exist					INT(11);
  	DECLARE Con_TarjetaSAFI				INT(11);
  	DECLARE Var_Control					VARCHAR(50);
  	DECLARE Var_Consecutivo				INT(11);
  	DECLARE Var_LoteDebitoSAFIID	    VARCHAR(10);
  	DECLARE Var_Nombres					TEXT;
  	DECLARE Var_NombrePerID				BIGINT(12);
  	DECLARE EsPersonalizadoSI			CHAR(1);


	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';						# Cadena vacia
	SET Fecha_Vacia			:= '1900-01-01';	# Fecha vacia
	SET Entero_Cero			:= 0;						# Entero Cero
	SET	SalidaSI        	:= 'S';				# Salida Si
	SET	SalidaNO        	:= 'N'; 			# Salida No
	SET Con_TarjetaSAFI 	:= 23;
	SET EsPersonalizadoSI	:= 'S';			#Indica si es personalizado}


ManejoErrores:BEGIN

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-LOTETIPOTARJETASALT');
		SET Var_Control	:='SQLEXCEPTION';
    END;

SET Var_patroc:=(SELECT PatrocinadorID  FROM  CATALOGOPATROCINADOR WHERE NombrePatroc = Par_NombrePatroc);


IF(IFNULL(Var_patroc, Entero_Cero) = Entero_Cero)  THEN
		SET Par_NumErr  := 001;
		SET Par_ErrMen  := "El patrocinador no existe";
		LEAVE ManejoErrores;
	END IF;

SET Var_exist :=(SELECT  count(TipoTarjetaDebID)  FROM  TIPOTARJETADEB  WHERE TipoTarjetaDebID = Par_TipoTarjetaDebID AND PatrocinadorID=Var_patroc);

IF(Var_exist = Entero_Cero) THEN
		SET Par_NumErr  := 002;
		SET Par_ErrMen  := "Los datos no Corresponden aun mismo producto";
		LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_EsPersonalizado,Cadena_Vacia) = Cadena_Vacia)THEN
		SET Par_NumErr  := 003;
		SET Par_ErrMen  := "El campo es personalizado esta vacio";
		LEAVE ManejoErrores;
END IF;

IF(Par_EsPersonalizado = EsPersonalizadoSI)THEN
	IF(IFNULL(Par_NombresPersonal,Cadena_Vacia) = Cadena_Vacia)THEN
		SET Par_NumErr  := 004;
		SET Par_ErrMen  := "La lista de nombres esta vacio";
		LEAVE ManejoErrores;
	END IF;
END IF;

SET Aud_FechaActual := CURRENT_TIMESTAMP();

SET Par_FolioInicial := (SELECT (MAX(FolioFinal))  FROM LOTETARJETADEBSAFI) + 1;

IF(Par_NumTarjetas > 1)THEN
    SET Par_FolioFinal := Par_FolioInicial + Par_NumTarjetas;
ELSE
    SET Par_FolioFinal := Par_FolioInicial;
END IF;


	CALL LOTETARDEBSAFIWSALT(
				Par_LoteDebitoSAFIID,	Par_TipoTarjetaDebID,	Aud_FechaActual,		Par_SucursalSolicita,	Par_UsuarioID,
				Par_NumTarjetas,		Entero_Cero, 			'N',		            Par_EsPersonalizado,	Par_NomArchiGen,
				Par_FolioInicial,		Par_FolioFinal,			Par_BitCargaID,			Par_ServiceCode,		SalidaNO,
				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

     IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
	END IF;

IF(Par_EsPersonalizado = EsPersonalizadoSI) THEN

	DROP TABLE IF EXISTS TMP_CLIPERSONALIZADO;
	CREATE TABLE TMP_CLIPERSONALIZADO (
	    NombrePerID         INT(11) AUTO_INCREMENT,
	    LoteDebitoID         INT(11),
	    NombresPersonalizado  VARCHAR(21),
	    PRIMARY KEY (NombrePerID)
	);

	SET Var_LoteDebitoSAFIID := CONCAT("(",Par_LoteDebitoSAFIID,",");

	SET Var_Nombres := REPLACE(REPLACE(REPLACE(Par_NombresPersonal,'{"customerName":',Var_LoteDebitoSAFIID),'},','),'),'}',');');
	SET @Var_Sentencia := CONCAT("INSERT INTO TMP_CLIPERSONALIZADO (LoteDebitoID,NombresPersonalizado) VALUES ", Var_Nombres);

	PREPARE REGISNOMBRESTMP FROM @Var_Sentencia;
	EXECUTE REGISNOMBRESTMP ;
	DEALLOCATE PREPARE REGISNOMBRESTMP;

	SELECT NombrePerID
		INTO Var_NombrePerID
	FROM TARLOTENOMBREPERSON
		ORDER BY NombrePerID DESC LIMIT 1;

	SET @Var_NombrePerID := IFNULL(Var_NombrePerID,Entero_Cero);

	INSERT INTO TARLOTENOMBREPERSON( NombrePerID,			LoteDebID,			NombrePerso,			EmpresaID,		Usuario,
				FechaActual, 								DireccionIP,		ProgramaID,  			Sucursal,		NumTransaccion)
	   SELECT @Var_NombrePerID := (@Var_NombrePerID + 1) ,	LoteDebitoID,		UPPER(NombresPersonalizado),	        Par_EmpresaID,
	   Aud_Usuario,     Aud_FechaActual,					Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion
		FROM TMP_CLIPERSONALIZADO;


 END IF;

		SET Par_NumErr  := 0;
        SET Par_ErrMen  := CONCAT('Lote de Tarjetas Agregado Exitosamente: ',Par_LoteDebitoSAFIID, '.');

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT
			Par_NumErr	AS NumErr,
			Par_ErrMen 	AS ErrMen,
			Par_LoteDebitoSAFIID AS consecutivo;
	END IF;

END  TerminaStore$$
