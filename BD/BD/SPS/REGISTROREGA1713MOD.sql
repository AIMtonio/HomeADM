-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGISTROREGA1713MOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGISTROREGA1713MOD`;DELIMITER $$

CREATE PROCEDURE `REGISTROREGA1713MOD`(
/*=======================================================================
--------- SP QUE MODIFICA UN REGISTRO PARA EL REGULATORIO A1713 -----------
========================================================================*/

	Par_Fecha             DATE, 			-- Fecha del registro
	Par_RegistroID        INT, 				-- Identificador del registro
	Par_TipoMovimientoID  INT,				-- Tipo de Movimiento
	Par_NombreFuncionario VARCHAR(250), 	-- Nombre completo del funcionario
	Par_RFC               VARCHAR(13), 		-- Rfc del funcionario
	Par_CURP              VARCHAR(18),      -- Curp del Funcionario
	Par_Profesion         INT, 				-- Profesion del funcionario
	Par_Telefono          VARCHAR(60), 		-- Telefono
	Par_Email             VARCHAR(30), 		-- Email
	Par_PaisID            INT, 				-- Clave del pais cnbv
	Par_EstadoID          INT, 				-- Clave del estado
	Par_MunicipioID       INT, 				-- Clave del municipio
	Par_LocalidadID       VARCHAR(16), 		-- Clave de la localidad CNBV
	Par_ColoniaID         INT, 				-- Clave de la colonia
	Par_CodigoPostal      VARCHAR(5), 		-- Codigo postal de la colonia
	Par_Calle             VARCHAR(250), 	-- Calle del domicilio
	Par_NumeroExt         VARCHAR(10), 		-- numero exterior
	Par_NumeroInt         VARCHAR(10), 		-- numero interior
	Par_FechaMovimiento   DATE, 			-- fecha del Movimiento
	Par_FechaInicioGes    DATE, 			-- Fecha de inicio de la gestion
	Par_FechaFinGestion   DATE, 			-- Fecha de fin de la gestion
	Par_OrganoID          INT, 				-- Clave del organo al que pertenece
	Par_CargoID           INT, 				-- Clave del cargo que tiene
	Par_PermanenteID      INT, 				-- Clave si es permanente o suplente
    Par_CausaBajaID	      INT, 				-- Clave causa de la baja
	Par_ManifestCumpID    INT, 				-- Clave de manifestacion del cumplimiento

	Par_Salida              CHAR(1),		-- parametro de salida
	INOUT Par_NumErr        INT(11), 		-- Numero de error
	INOUT Par_ErrMen        VARCHAR(400),  	-- Mensaje de salida

	Par_EmpresaID           INT(11),		-- Auditoria
	Aud_Usuario             INT(11),		-- Auditoria
	Aud_FechaActual         DATETIME,		-- Auditoria
	Aud_DireccionIP         VARCHAR(15),	-- Auditoria
	Aud_ProgramaID          VARCHAR(50),	-- Auditoria
	Aud_Sucursal            INT(11),		-- Auditoria
	Aud_NumTransaccion      BIGINT(20) 		-- Auditoria
)
TerminaStore: BEGIN
  -- Declaracion de Variables
  DECLARE Var_Control       VARCHAR(100); -- Campo de control
  DECLARE Var_Periodo       VARCHAR(6);  -- Periodo del Reporte
  DECLARE Var_Destino       VARCHAR(8);  -- Variable para validar que un destino de pagos existe
  DECLARE Var_Plazo         VARCHAR(8);  -- Variable para validar que un plazo existe
  DECLARE Var_TipoCred      VARCHAR(8);  -- Variable para validar que un tipo de creditos existe
  DECLARE Var_TipoGaran     VARCHAR(8);  -- Variable para validar que un tipo de garantia existe
  DECLARE Var_TipoPres      VARCHAR(8);  -- Variable para validar que tipo de prestamista existe
   DECLARE Var_Consecutivo   INT; 		 -- Consecutivo de Registro
  DECLARE Var_Formulario    CHAR(4); 	 -- Clave del Regulatorio
  DECLARE Var_ClaveEntidad  VARCHAR(6);  -- Clave de la entidad

  -- Declaracion de Constantes
  DECLARE SalidaSI          CHAR(1);
  DECLARE Entero_Cero       INT;
  DECLARE Decimal_Cero      DECIMAL(14,2);
  DECLARE Cadena_Vacia      CHAR;
  DECLARE Entero_Uno        INT;
  DECLARE Fecha_Vacia		DATE;

  -- Asignacion de Constantes
  SET SalidaSI            :='S';
  SET Entero_Cero         :=0;
  SET Decimal_Cero        :=0.0;
  SET Cadena_Vacia        :='';
  SET Entero_Uno          := 1;
  SET Fecha_Vacia		  := '1900-01-01';

  ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
					concretar la operacion.Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-REGISTROREGA1713MOD');
		SET Var_Control := 'SQLEXCEPTION';
    END;



	 IF IFNULL(Par_Fecha,Fecha_Vacia) = Fecha_Vacia THEN
		SET Par_NumErr  := 01;
		SET Par_ErrMen  := 'La Fecha esta Vacia.';
		SET Var_Control := 'fecha';
		LEAVE ManejoErrores;
	  END IF;


	  IF IFNULL(Par_TipoMovimientoID,Entero_Cero) = Entero_Cero THEN
		SET Par_NumErr  := 03;
		SET Par_ErrMen  := 'El Tipo de Movimiento Esta Vacio.';
		SET Var_Control := 'tipoMovimientoID';
		LEAVE ManejoErrores;
	  END IF;


	  IF IFNULL(Par_NombreFuncionario ,Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr  := 04;
		SET Par_ErrMen  := 'El Nombre de Funcionario Esta Vacio.';
		SET Var_Control := 'nombreFuncionario';
		LEAVE ManejoErrores;
	  END IF;

	  IF IFNULL(Par_RFC,Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr  := 05;
		SET Par_ErrMen  := 'El RFC Esta Vacio.';
		SET Var_Control := 'rfcFuncionario';
		LEAVE ManejoErrores;
	  END IF;

       IF EXISTS (SELECT RFC FROM REGISTROREGA1713 WHERE RFC = Par_RFC
													AND Fecha = Par_fecha
													AND RegistroID <> Par_RegistroID) THEN
		SET Par_NumErr  := 27;
		SET Par_ErrMen  := 'RFC Registrado Previamente.';
		SET Var_Control := 'rfcFuncionario';
		LEAVE ManejoErrores;
	  END IF;

	  IF IFNULL(Par_CURP,Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr  := 06;
		SET Par_ErrMen  := 'La CURP Esta Vacia.';
		SET Var_Control := 'curpFuncionario';
		LEAVE ManejoErrores;
	  END IF;

       IF EXISTS (SELECT CURP FROM REGISTROREGA1713 WHERE CURP = Par_CURP
													AND Fecha = Par_fecha
													AND RegistroID <> Par_RegistroID) THEN
		SET Par_NumErr  := 28;
		SET Par_ErrMen  := 'CURP Registrada Previamente.';
		SET Var_Control := 'rfcFuncionario';
		LEAVE ManejoErrores;
	  END IF;



	  IF IFNULL(Par_Telefono,Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr  := 08;
		SET Par_ErrMen  := 'El Telefono esta Vacio.';
		SET Var_Control := 'telefono';
		LEAVE ManejoErrores;
	  END IF;

	  IF IFNULL(Par_Email,Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr  := 09;
		SET Par_ErrMen  := 'El Correo Esta Vacio.';
		SET Var_Control := 'correoElectronico';
		LEAVE ManejoErrores;
	  END IF;


	  IF IFNULL(Par_PaisID,Entero_Cero) = Entero_Cero THEN
		SET Par_NumErr  := 10;
		SET Par_ErrMen  := 'El Pais Esta Vacio.';
		SET Var_Control := 'paisID';
		LEAVE ManejoErrores;
	  END IF;


	  IF IFNULL(Par_EstadoID,Entero_Cero) = Entero_Cero THEN
		SET Par_NumErr  := 11;
		SET Par_ErrMen  := 'El Estado Esta Vacio.';
		SET Var_Control := 'estadoID';
		LEAVE ManejoErrores;
	  END IF;


	  IF IFNULL(Par_MunicipioID,Entero_Cero) = Entero_Cero THEN
		SET Par_NumErr  := 12;
		SET Par_ErrMen  := 'El Municipio Esta Vacio.';
		SET Var_Control := 'municipioID';
		LEAVE ManejoErrores;
	  END IF;


	  IF IFNULL(Par_LocalidadID,Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr  := 13;
		SET Par_ErrMen  := 'La Localidad esta Vacio.';
		SET Var_Control := 'localidadID';
		LEAVE ManejoErrores;
	  END IF;


	  IF IFNULL(Par_ColoniaID,Entero_Cero) = Entero_Cero THEN
		SET Par_NumErr  := 14;
		SET Par_ErrMen  := 'La Colonia Esta Vacia.';
		SET Var_Control := 'coloniaID';
		LEAVE ManejoErrores;
	  END IF;


	  IF IFNULL(Par_CodigoPostal,Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr  := 15;
		SET Par_ErrMen  := 'El Codigo Postal Esta Vacio.';
		SET Var_Control := 'codigoPostal';
		LEAVE ManejoErrores;
	  END IF;

	  IF IFNULL(Par_Calle,Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr  := 16;
		SET Par_ErrMen  := 'La Calle Esta Vacia.';
		SET Var_Control := 'calle';
		LEAVE ManejoErrores;
	  END IF;


	  IF IFNULL(Par_NumeroExt,Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr  := 17;
		SET Par_ErrMen  := 'El Numero Exterior Esta Vacio.';
		SET Var_Control := 'numeroExt';
		LEAVE ManejoErrores;
	  END IF;


	  IF IFNULL(Par_NumeroInt,Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr  := 18;
		SET Par_ErrMen  := 'El Numero Interior Esta Vacio.';
		SET Var_Control := 'numeroInt';
		LEAVE ManejoErrores;
	  END IF;


	  IF IFNULL(Par_FechaMovimiento,Fecha_Vacia) = Fecha_Vacia THEN
		SET Par_NumErr  := 19;
		SET Par_ErrMen  := 'La Fecha de Movimiento Esta Vacia.';
		SET Var_Control := 'fechaMovimiento';
		LEAVE ManejoErrores;
	  END IF;

	  IF IFNULL(Par_FechaInicioGes,Fecha_Vacia) = Fecha_Vacia THEN
		SET Par_NumErr  := 20;
		SET Par_ErrMen  := 'La Fecha de Inicio de Gestion Esta Vacia.';
		SET Var_Control := 'inicioGestion';
		LEAVE ManejoErrores;
	  END IF;


	  IF IFNULL(Par_FechaFinGestion,Fecha_Vacia) = Fecha_Vacia THEN
		SET Par_NumErr  := 21;
		SET Par_ErrMen  := 'La Fecha de Fin de Gestion Esta Vacia.';
		SET Var_Control := 'conclusionGestion';
		LEAVE ManejoErrores;
	  END IF;

	  IF IFNULL(Par_OrganoID,Entero_Cero) = Entero_Cero THEN
		SET Par_NumErr  := 22;
		SET Par_ErrMen  := 'El Organo Esta Vacio.';
		SET Var_Control := 'organoID';
		LEAVE ManejoErrores;
	  END IF;




	  IF IFNULL(Par_PermanenteID,Entero_Cero) = Entero_Cero THEN
		SET Par_NumErr  := 24;
		SET Par_ErrMen  := 'El Campo Permanente Esta Vacio.';
		SET Var_Control := 'permanenteSupID';
		LEAVE ManejoErrores;
	  END IF;





	 IF IFNULL(Par_ManifestCumpID,Entero_Cero) = Entero_Cero THEN
		SET Par_NumErr  := 26;
		SET Par_ErrMen  := 'La Manifestacion del Cumplimiento Esta Vacia.';
		SET Var_Control := 'manifestacionID';
		LEAVE ManejoErrores;
	  END IF;

	 UPDATE  REGISTROREGA1713 SET
		 TipoMovimientoID 	=   Par_TipoMovimientoID ,
		 NombreFuncionario	=   Par_NombreFuncionario,
		 RFC				=   Par_RFC,
		 CURP 				=   Par_CURP,
		 Profesion 			=   Par_Profesion,

		 Telefono			=   Par_Telefono,
		 Email 				=   Par_Email,
		 PaisID 			=   Par_PaisID,
		 EstadoID 			=   Par_EstadoID ,
		 MunicipioID 		=   Par_MunicipioID,

		 LocalidadID 		=   Par_LocalidadID,
		 ColoniaID 			=   Par_ColoniaID,
		 CodigoPostal 		=   Par_CodigoPostal,
		 Calle 				=   Par_Calle,
		 NumeroExt 			=   Par_NumeroExt,

		 NumeroInt 			=   Par_NumeroInt,
		 FechaMovimiento 	=   Par_FechaMovimiento,
		 FechaInicioGes 	=   Par_FechaInicioGes,
		 FechaFinGestion 	=   Par_FechaFinGestion,
		 OrganoID 			=   Par_OrganoID,

		 CargoID 			=   Par_CargoID,
		 PermanenteID		=   Par_PermanenteID,
		 CausaBajaID 		=   Par_CausaBajaID ,
		 ManifestCumpID 	=   Par_ManifestCumpID,
		 EmpresaID 			=   Par_EmpresaID,

		 Usuario 			=   Aud_Usuario,
		 FechaActual 		=   Aud_FechaActual,
		 DireccionIP 		=   Aud_DireccionIP,
		 ProgramaID 		=   Aud_ProgramaID,
		 Sucursal 			=   Aud_Sucursal,

		 NumTransaccion 	=   Aud_NumTransaccion
	 WHERE Fecha = Par_Fecha
	 AND  RegistroID = Par_RegistroID;


     SET Par_NumErr  := Entero_Cero;
     SET Par_ErrMen  := CONCAT('Registro Modificado Correctamente: ',Par_RegistroID);
     SET Var_Control := 'registroID';

END ManejoErrores;
 IF (Par_Salida = SalidaSI) THEN
     SELECT Par_NumErr  AS NumErr,
            Par_ErrMen  AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
 END IF;

END TerminaStore$$