-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZAARCHIVOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZAARCHIVOSALT`;DELIMITER $$

CREATE PROCEDURE `POLIZAARCHIVOSALT`(

	Par_PolizaID			INT(20),
	Par_Observacion  		VARCHAR(200),
	Par_Recurso				VARCHAR(200),
	Par_Extension			VARCHAR(500),
	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)

	)
TerminaStore:BEGIN

-- DeclaraciÃ³n de Constantes
DECLARE Con_TipoDocumento			INT(11);
DECLARE Cadena_Vacia				CHAR(1);
DECLARE Entero_Cero					INT(1);
DECLARE SalidaSI					CHAR(1);

-- DeclaracÃ­ON de Variables
DECLARE Var_PolizaArchivosID  		INT(11);		-- consecutivo de la tabla
DECLARE Var_ArchivoPolID			INT(11);		-- consecutivo de archivos por poliza
DECLARE Var_PolizaID				INT(20);		-- Numero de poliza
DECLARE varControl      			CHAR(15);
DECLARE var_DesTipDoc				VARCHAR(50);
DECLARE varRecurso					VARCHAR(100);

-- AsignaciÃ³n de Constantes
SET Con_TipoDocumento				:=51;		-- correspondiente a DOCUMENTO POLIZA CONTABLE en la tabla de TIPOSDOCUMENTOS
SET	Cadena_Vacia					:= '';		--  Cadena Vacia
SET	Entero_Cero						:= 0;		-- Entero Cero
SET	SalidaSI						:= 'S';		-- Salida Si
SET varControl						:='polizaID';
/* Inicializar parametros de salida */
SET     Par_NumErr  		:= 1;
SET     Par_ErrMen  		:= Cadena_Vacia;

SET 	Var_PolizaArchivosID:=0;
SET 	Var_ArchivoPolID	:=0;
SET		Var_PolizaID		:=0;

ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr := 999;
					SET Par_ErrMen := CONCAT("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-POLIZAARCHIVOSALT");
				END;



SELECT PolizaID  INTO Var_PolizaID
				FROM POLIZACONTABLE
				WHERE PolizaID = Par_PolizaID;

SET Var_PolizaID:= IFNULL(Var_PolizaID, Cadena_Vacia);

IF(Var_PolizaID = Entero_Cero ) THEN
	SET Par_NumErr  := '001';
    SET Par_ErrMen  := CONCAT('La poliza ', Var_PolizaID, ' no Existe');
    SET varControl  := 'polizaID' ;
LEAVE ManejoErrores;
END IF;

IF(Par_Recurso = Cadena_Vacia ) THEN
	SET Par_NumErr  := '002';
    SET Par_ErrMen  := CONCAT('El Recurso esta Vacio');
    SET varControl  := 'polizaID' ;
LEAVE ManejoErrores;
END IF;

-- consecutivo  general de la tabla
SET Var_PolizaArchivosID := (SELECT IFNULL(MAX(PolizaArchivosID),Entero_Cero)  FROM POLIZAARCHIVOS);
SET Var_PolizaArchivosID := IFNULL(Var_PolizaArchivosID, Entero_Cero) + 1;

-- consecutivo archivo por poliza
SET	Var_ArchivoPolID	:=(SELECT IFNULL(MAX(ArchivoPolID),Entero_Cero)+1
												FROM POLIZAARCHIVOS
												WHERE Par_PolizaID = PolizaID);

SET Aud_FechaActual := CURRENT_TIMESTAMP();


SET var_DesTipDoc :=  'POLIZA CONTABLE';
SET var_DesTipDoc :=IFNULL(var_DesTipDoc,Cadena_Vacia);

IF(var_DesTipDoc= Cadena_Vacia)THEN
	SET Par_NumErr  := '003';
    SET Par_ErrMen  := CONCAT('La descripcion del tipo de documento esta vacia');
    SET varControl  := 'polizaID' ;
LEAVE ManejoErrores;
END IF;

SET varRecurso := CONCAT(Par_Recurso,var_DesTipDoc,"/Archivo", RIGHT(CONCAT("00000",CONVERT(Var_ArchivoPolID, CHAR)), 5),Par_Extension );
SET varRecurso:= IFNULL(varRecurso,Cadena_Vacia );
IF(varRecurso= Cadena_Vacia)THEN
	SET Par_NumErr  := '004';
    SET Par_ErrMen  := CONCAT('El recurso  formado esta vacio');
    SET varControl  := 'polizaID' ;
LEAVE ManejoErrores;
END IF;

 INSERT INTO POLIZAARCHIVOS(
        PolizaArchivosID,		PolizaID,		ArchivoPolID,		TipoDocumento,		Observacion,
        Recurso,        		EmpresaID,		Usuario,			FechaActual,		DireccionIP,
		ProgramaID, 			Sucursal, 		NumTransaccion)
        VALUES(
        Var_PolizaArchivosID,	Par_PolizaID,	Var_ArchivoPolID,  	Con_TipoDocumento,	Par_Observacion,
        varRecurso,    			Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,     	Aud_Sucursal,   Aud_NumTransaccion);

    SET Par_NumErr := 0;
    SET Par_ErrMen := CONCAT("El Archivo se Adjunto Correctamente: ",CONVERT(Var_ArchivoPolID , CHAR));

END ManejoErrores;  -- END del Handler de Errores

IF (Par_Salida = SalidaSI) THEN
     SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            varControl AS control,
            Var_ArchivoPolID  AS consecutivo,
			varRecurso		 AS recurso;
END IF;

END TerminaStore$$