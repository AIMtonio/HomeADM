-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-REGULATORIOA1713ALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HIS-REGULATORIOA1713ALT`;DELIMITER $$

CREATE PROCEDURE `HIS-REGULATORIOA1713ALT`(
-- SP QUE AGREGA UN REGISTRO PARA EL REGULATORIO A1713
    Par_Fecha           	 DATE,
	Par_TipoMovimiento		 VARCHAR(3),
    Par_NombreFuncionario	 VARCHAR(100),
    Par_RFC					 VARCHAR(13),
    Par_CURP				 VARCHAR(18),

    Par_Profesion			 INT,
    Par_CalleDomicilio		 VARCHAR(150),
    Par_NumeroExt			 VARCHAR(10),
    Par_NumeroInt			 VARCHAR(10),
    Par_ColoniaDomicilio 	 VARCHAR(150),

    Par_CodigoPostal		 VARCHAR(5),
    Par_Localidad			 VARCHAR(12),
    Par_Estado				 INT,
	Par_Pais				 INT,
    Par_Telefono             VARCHAR(20),

    Par_Email				 VARCHAR(75),
	Par_FechaMovimiento      DATE,
    Par_FechaInicio			 DATE,
   	Par_OrganoPerteneciente  INT,
    Par_Cargo				 INT,

    Par_Permanente           INT,
    Par_ManifestCumplimiento INT,
    Par_Municipio			 INT,
	Par_Salida          	 CHAR(1),
    INOUT Par_NumErr    	 INT,

    INOUT Par_ErrMen    	VARCHAR(400),
	Aud_Empresa		    	INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
    Aud_DireccionIP			VARCHAR(15),

    Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
    Aud_NumTransaccion		BIGINT

	)
TerminaStore: BEGIN
-- Declaracion de Variables
DECLARE Var_Control    		VARCHAR(100);
DECLARE Var_Fecha 			INT;			-- Variable almacenar el valor de Fecha de DATE a INTEGER
DECLARE Var_FechaInicio		INT(11);
DECLARE Var_FechaMovimiento INT(11);

DECLARE Var_Financiera  	VARCHAR(8);		-- Variable para validar que una Entidad financiera existe
DECLARE Var_Profesion   	VARCHAR(6);		-- Variable para validar que la Profesion sea una o valida
DECLARE Var_Estado			INT;			-- Variable para validar que el Estado sea una opcion valida
DECLARE Var_Pais			INT;			-- Variable para validar que el Pais sea una opcion valida
DECLARE Var_Municipio       INT;
DECLARE Var_Localidad		VARCHAR(13);
DECLARE Var_Colonia			INT;
DECLARE Var_Organo			VARCHAR(6);		-- Variable para validar que el Organo perteneciente sea una opcion valida
DECLARE Var_Cargo 			VARCHAR(6);		-- Variable para validar que el Cargo sea una opcion valida
DECLARE Var_Permanente		VARCHAR(6);		-- Variable para validar que Permante o Suplente sean las opciones validas
DECLARE Var_Manifestacion	VARCHAR(6);		-- Variable para validar que la Manifestacion de Cumplimiento sea una opcion valida
DECLARE Var_TipoMovimiento	VARCHAR(6);
DECLARE Var_CURP			VARCHAR(10);    -- Variable para validar que los primeros diez datos del RFC coincidan con la CURP
DECLARE Var_RFC			    VARCHAR(10);    -- Variable para validar que los primeros diez datos del RFC coincidan con la CURP
DECLARE Var_Consecutivo		INT;
-- Declaracion de Constantes
DECLARE SalidaSI			CHAR(1);
DECLARE Entero_Cero			INT;
DECLARE Cadena_Vacia		CHAR;
DECLARE Var_Subreporte  	VARCHAR(6);
DECLARE Var_Entidad			VARCHAR(6);
DECLARE Entero_Ocho     	INT;           -- Limite de 8 caracteres para el ID de la Entidad
DECLARE Entero_Trece		INT;		   -- Limite de 13 caracteres para RFC
DECLARE Entero_Dieciocho 	INT;
DECLARE FechaVacia			DATE;	   -- Limite de 18 caracteres para CURP

-- Asignacion de Constantes
SET SalidaSI		 := 'S';
SET Entero_Cero		 := 0;
SET Cadena_Vacia	 := '';
SET Par_NumErr		 := 1;
SET Par_ErrMen		 := Cadena_Vacia;
SET Var_Subreporte   := '1713';
SET Entero_Ocho      := 8;
SET Entero_Trece	 := 13;
SET Entero_Dieciocho := 18;
SET FechaVacia		 := '1900-01-01';


SELECT ClaveEntidad INTO Var_Entidad FROM PARAMETROSSIS WHERE EmpresaID = Aud_Empresa;

 ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          SET Par_NumErr = 999;
          SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion.'
          'Disculpe las molestias que esto le ocasiona. Ref: SP-HIS-REGULATORIOA1713ALT');
          SET Var_Control = 'sqlException';
        END;

	SELECT REPLACE (CONVERT(Par_Fecha,CHAR),'-',Cadena_Vacia) INTO Var_Fecha;
	 SELECT (COUNT(*)+1) INTO Var_Consecutivo FROM
    `HIS-REGULATORIOA1713` WHERE Fecha = Var_Fecha;

    SET Var_Consecutivo = IFNULL(Var_Consecutivo,Entero_Cero);
	IF (Par_Fecha=Entero_Cero)THEN
		SET Par_NumErr  := 1;
        SET Par_ErrMen  := 'La Fecha esta vacia ';
        LEAVE ManejoErrores;
	END IF;
	 SELECT CodigoOpcion INTO Var_TipoMovimiento FROM OPCIONESMENUREG WHERE CodigoOpcion = Par_TipoMovimiento AND MenuID = 17;

    IF (IFNULL(Var_TipoMovimiento,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 2;
        SET Par_ErrMen  := 'El Tipo de Movimiento esta vacio';
        LEAVE ManejoErrores;
	END IF;

    IF(Par_NombreFuncionario=Cadena_Vacia)THEN
		SET Par_NumErr:= 5;
		SET Par_ErrMen:= 'El Nombre del Funcionario esta vacio';
        LEAVE ManejoErrores;
	END IF;

    IF(LENGTH(Par_RFC)=Cadena_Vacia)THEN
        SET Par_NumErr:= 6;
        SET Par_ErrMen:= 'El RFC esta vacio';
        LEAVE ManejoErrores;
    END IF;

    IF(LENGTH(Par_RFC)!=Entero_Trece)THEN
		SET Par_NumErr:= 6;
		SET Par_ErrMen:= 'El RFC debe tener una longitud de 13 caracteres';
        LEAVE ManejoErrores;
	END IF;

    IF(LENGTH(Par_CURP)=Cadena_Vacia)THEN
        SET Par_NumErr:= 7;
        SET Par_ErrMen:= 'La CURP esta vacia';
        LEAVE ManejoErrores;
    END IF;

    IF(LENGTH(Par_CURP)!=Entero_Dieciocho)THEN
		SET Par_NumErr:= 7;
		SET Par_ErrMen:= 'La CURP debe tener una longitud de 18 caracteres';
        LEAVE ManejoErrores;
	END IF;


    SELECT CodigoOpcion INTO Var_Profesion FROM OPCIONESMENUREG WHERE CodigoOpcion = Par_Profesion AND MenuID = 16;

	IF (IFNULL(Var_Profesion,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 8;
        SET Par_ErrMen  := 'Seleccione el Titulo o Profesion';
        LEAVE ManejoErrores;
	END IF;

    IF (Par_Profesion<Entero_Cero)THEN
		SET Par_NumErr  := 9;
        SET Par_ErrMen  := 'Seleccione el Titulo o Profesion';
        LEAVE ManejoErrores;
	END IF;

	IF (Par_CalleDomicilio=Cadena_Vacia)THEN
		SET Par_NumErr  := 10;
        SET Par_ErrMen  := 'La Calle esta vacia';
        LEAVE ManejoErrores;
	END IF;

    IF (Par_NumeroExt=Cadena_Vacia)THEN
		SET Par_NumErr  := 11;
        SET Par_ErrMen  := 'El Numero Exterior esta vacio';
        LEAVE ManejoErrores;
	END IF;
    IF (Par_NumeroInt=Cadena_Vacia)THEN
		SET Par_NumErr  := 11;
        SET Par_ErrMen  := 'El Numero Interior esta vacio';
        LEAVE ManejoErrores;
	END IF;

	IF (Par_CodigoPostal=Cadena_Vacia)THEN
		SET Par_NumErr  := 14;
        SET Par_ErrMen  := 'El Codigo Postal esta vacio';
        LEAVE ManejoErrores;
	END IF;

      SELECT PaisID INTO Var_Pais FROM PAISES WHERE PaisRegSITI = Par_Pais;

	IF (IFNULL(Var_Pais,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 18;
        SET Par_ErrMen  := 'El Pais esta vacio';
        LEAVE ManejoErrores;
	END IF;

	IF (Par_Pais=Entero_Cero)THEN
		SET Par_NumErr  := 19;
        SET Par_ErrMen  := 'El Pai­s esta vacio';
        LEAVE ManejoErrores;
	END IF;

    SELECT EstadoID INTO Var_Estado FROM ESTADOSREPUB WHERE EstadoID = Par_Estado;

	IF (IFNULL(Var_Estado,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 16;
        SET Par_ErrMen  := 'El Estado esta vacio';
        LEAVE ManejoErrores;
	END IF;

	IF (Par_Estado=Entero_Cero)THEN
		SET Par_NumErr  := 17;
        SET Par_ErrMen  := 'El Estado esta vacio';
        LEAVE ManejoErrores;
	END IF;

	SELECT MunicipioID INTO Var_Municipio FROM MUNICIPIOSREPUB WHERE EstadoID = Par_Estado AND MunicipioID=Par_Municipio ;

	IF (IFNULL(Var_Municipio,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 36;
        SET Par_ErrMen  := 'El municipio esta vacio';
        LEAVE ManejoErrores;
	END IF;

    IF (Par_Municipio=Entero_Cero)THEN
		SET Par_NumErr  := 32;
        SET Par_ErrMen  := 'El Municipio esta vacio';
        LEAVE ManejoErrores;
	END IF;


	SELECT	ColoniaCNBV	INTO Var_Localidad	FROM COLONIASREPUB	WHERE EstadoID	=	Par_Estado	AND	MunicipioID	=	Par_Municipio	AND	ColoniaCNBV	=	Par_Localidad;
	IF (IFNULL(Var_Localidad,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 34;
        SET Par_ErrMen  := concat('La localidad esta vacia: Fila ',Var_Consecutivo);
        LEAVE ManejoErrores;
	END IF;


	IF (Par_Localidad=Cadena_Vacia)THEN
		SET Par_NumErr  := 15;
        SET Par_ErrMen  := 'La Localidad esta vacia';
        LEAVE ManejoErrores;
	END IF;

	 SELECT ColoniaID INTO Var_Colonia FROM COLONIASREPUB WHERE EstadoID = Par_Estado AND MunicipioID=Par_Municipio AND ColoniaID= Par_ColoniaDomicilio;

	IF (IFNULL(Var_Colonia,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 35;
        SET Par_ErrMen  := 'La colonia esta vacia';
        LEAVE ManejoErrores;
	END IF;


	IF (Par_ColoniaDomicilio=Cadena_Vacia)THEN
		SET Par_NumErr  := 13;
        SET Par_ErrMen  := 'La Colonia esta vacia';
        LEAVE ManejoErrores;
	END IF;

    IF (Par_Telefono=Cadena_Vacia)THEN
		SET Par_NumErr  := 20;
        SET Par_ErrMen  := 'El Telefono esta vacio';
        LEAVE ManejoErrores;
	END IF;

    IF (Par_Email=Cadena_Vacia)THEN
		SET Par_NumErr  := 21;
        SET Par_ErrMen  := 'El Correo electronico esta vacio';
        LEAVE ManejoErrores;
	END IF;
     IF (Par_FechaMovimiento=FechaVacia)THEN
		SET Par_NumErr  := 22;
        SET Par_ErrMen  := 'La Fecha del Movimiento esta vacio';
        LEAVE ManejoErrores;
	END IF;
        SELECT REPLACE (CONVERT(Par_FechaMovimiento,CHAR),'-',Cadena_Vacia) INTO Var_FechaMovimiento;

    SELECT REPLACE (CONVERT(Par_FechaInicio,CHAR),'-',Cadena_Vacia) INTO Var_FechaInicio;
    IF (Par_FechaInicio=FechaVacia)THEN
		SET Par_NumErr  := 23;
        SET Par_ErrMen  := 'La Fecha de Inicio o Conclusion de gestion esto vacio';
        LEAVE ManejoErrores;
	END IF;


    SELECT CodigoOpcion INTO Var_Organo FROM OPCIONESMENUREG WHERE CodigoOpcion = Par_OrganoPerteneciente AND MenuID = 8;

    IF (IFNULL(Var_Organo,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 24;
        SET Par_ErrMen  := 'Seleccione el Organo al que pertenece';
        LEAVE ManejoErrores;
	END IF;

    IF (Par_OrganoPerteneciente=Entero_Cero)THEN
		SET Par_NumErr  := 25;
        SET Par_ErrMen  := 'Seleccione el Organo al que pertenece';
        LEAVE ManejoErrores;
	END IF;

    SELECT CodigoOpcion INTO Var_Cargo FROM OPCIONESMENUREG WHERE CodigoOpcion = Par_Cargo AND MenuID = 6;

    IF (IFNULL(Var_Cargo,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 26;
        SET Par_ErrMen  := 'Seleccione el cargo';
        LEAVE ManejoErrores;
	END IF;

    IF (Par_Cargo=Entero_Cero)THEN
		SET Par_NumErr  := 27;
        SET Par_ErrMen  := 'Seleccione el Cargo';
        LEAVE ManejoErrores;
	END IF;

    SELECT CodigoOpcion INTO Var_Permanente FROM OPCIONESMENUREG WHERE CodigoOpcion = Par_Permanente AND MenuID = 9;

    IF (IFNULL(Var_Permanente,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 28;
        SET Par_ErrMen  := 'Seleccione Permanenente o Suplente';
        LEAVE ManejoErrores;
	END IF;

    IF (Par_Permanente=Entero_Cero)THEN
		SET Par_NumErr  := 29;
        SET Par_ErrMen  := 'Seleccione Permanenente o Suplente';
        LEAVE ManejoErrores;
	END IF;

    SELECT CodigoOpcion INTO Var_Manifestacion FROM OPCIONESMENUREG WHERE CodigoOpcion = Par_ManifestCumplimiento AND MenuID = 7;

    IF (IFNULL(Var_Manifestacion,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr  := 30;
        SET Par_ErrMen  := 'Seleccione la Manifestacion de Cumplimiento';
        LEAVE ManejoErrores;
	END IF;

    IF (Par_ManifestCumplimiento=Entero_Cero)THEN
		SET Par_NumErr  := 31;
        SET Par_ErrMen  := 'Seleccione la Manifestacion de Cumplimiento';
        LEAVE ManejoErrores;
	END IF;


    SELECT SUBSTRING(Par_CURP,1,10) INTO Var_CURP;
	SELECT SUBSTRING(Par_RFC,1,10) INTO Var_RFC;
	IF (SELECT STRCMP(Var_CURP, Var_RFC)!=0)THEN
		SET Par_NumErr  := 33;
        SET Par_ErrMen  := 'Los primeros diez datos del RFC no coindicen con la CURP ';
        LEAVE ManejoErrores;
	END IF;



	INSERT INTO `HIS-REGULATORIOA1713`(
    Fecha,					ClaveEntidad,		Subreporte,		TipoMovimiento,			NombreFuncionario,
    RFC,					CURP,	    		Profesion,		CalleDomicilio,			NumeroExt,
    NumeroInt,				ColoniaDomicilio,	CodigoPostal,	Localidad,				Estado,
    Pais,					Telefono,	    	Email,			FechaMovimiento,		FechaInicio,
    OrganoPerteneciente,	Cargo,  			Permanente,		ManifestCumplimiento,	Municipio,
    Consecutivo,         	EmpresaID,			Usuario,		FechaActual,	        DireccionIP,   			ProgramaID,
    Sucursal,			    NumTransaccion
    )
    VALUES(
    Var_Fecha,				Var_Entidad,		    Var_Subreporte,			Par_TipoMovimiento,			Par_NombreFuncionario,
	Par_RFC,				Par_CURP,		    	Par_Profesion,			Par_CalleDomicilio,			Par_NumeroExt,
    Par_NumeroInt,			Par_ColoniaDomicilio,	Par_CodigoPostal,		Par_Localidad,				Par_Estado,
	Par_Pais, 	    		Par_Telefono,			Par_Email,				Var_FechaMovimiento,   	 	Var_FechaInicio,
	Par_OrganoPerteneciente,Par_Cargo,				Par_Permanente,			Par_ManifestCumplimiento,	Par_Municipio,
    Var_Consecutivo,        Aud_Empresa,			Aud_Usuario,	    	Aud_FechaActual,		    Aud_DireccionIP,
	Aud_ProgramaID,			Aud_Sucursal,	  		Aud_NumTransaccion

    );

    SET Par_NumErr  := 0;
	SET Par_ErrMen  := 'Reporte Regulatorio A1713 agregado correctamente';

END ManejoErrores;  -- End del Handler de Errores
IF (Par_Salida = SalidaSI) THEN
     SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'regulatorioA1713ID' AS control,
            Entero_Cero AS consecutivo;
 END IF;

END TerminaStore$$