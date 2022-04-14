-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIOMENORALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOCIOMENORALT`;
DELIMITER $$

CREATE PROCEDURE `SOCIOMENORALT`(
	Par_SucursalOri			INT(11),
    Par_TipoPersona   		CHAR(1),
    Par_Titulo          	VARCHAR(10),
    Par_PrimerNom       	VARCHAR(50),
    Par_SegundoNom      	VARCHAR(50),

    Par_TercerNom       	VARCHAR(50),
    Par_ApellidoPat     	VARCHAR(50),
    Par_ApellidoMat     	VARCHAR(50),
    Par_FechaNac        	VARCHAR(50),
    Par_LugarNac        	INT(11),

    Par_estadoID        	INT(11),
    Par_Nacion          	CHAR(1),
    Par_PaisResi        	INT(11),
    Par_Sexo            	CHAR(1),
    Par_CURP            	CHAR(18),

    Par_RFC             	CHAR(13),
    Par_EstadoCivil     	CHAR(2),
    Par_TelefonoCel     	VARCHAR(20) ,
    Par_Telefono        	VARCHAR(20) ,
    Par_Correo          	VARCHAR(50),

    Par_RazonSocial     	VARCHAR(150),
    Par_TipoSocID       	INT(11),
    Par_RFCpm           	CHAR(13),
    Par_GrupoEmp        	INT(11),
    Par_Fax             	VARCHAR(20),

    Par_OcupacionID     	INT(11),
    Par_Puesto          	VARCHAR(100),
    Par_LugardeTrab     	VARCHAR(100),
    Par_AntTra          	FLOAT,
    Par_TelTrabajo      	VARCHAR(20),

    Par_Clasific        	CHAR(1),
    Par_MotivoApert     	CHAR(1),
    Par_PagaISR         	CHAR(1),
    Par_PagaIVA         	CHAR(1),
    Par_PagaIDE         	CHAR(1),

    Par_NivelRiesgo     	CHAR(1),
    Par_SecGeneral      	INT(11),
    Par_ActBancoMX      	VARCHAR(15),
    Par_ActINEGI        	INT(11),
    Par_SecEconomic     	INT(11),

    Par_ActFR				BIGINT,
    Par_ActFOMUR			INT(11),
    Par_PromotorIni     	INT(11),
    Par_PromotorActual  	INT(11),
    Par_ProspectoID			INT(11),

    Par_EsMenorEdad      	CHAR(1),
    Par_ClienteTutorID   	INT(11),
    Par_NombreTutor     	VARCHAR(150),
	Par_ParentescoID		INT(11),

    Par_ExtTelefonoPart		VARCHAR(6),
	Par_EjecutivoCap        INT(11),
    Par_PromotorExtInv      INT(11),

    Par_EmpresaID       	INT(11),
    Par_Salida    			CHAR(1),

    inout	Par_NumErr 		INT(11),
    inout	Par_ErrMen  	VARCHAR(400),
	inout   Par_Cliente   	INT(11),

    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion  	bigint(20)
)
TerminaStore: BEGIN


	DECLARE	Estatus_Activo		CHAR(1);
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	PaisMex				INT;
	DECLARE Salida_SI 			CHAR(1);
	DECLARE Salida_NO 			CHAR(1);
	DECLARE	Per_Fisica			CHAR(1);
	DECLARE	Per_ActEmp			CHAR(1);
	DECLARE	Per_Moral			CHAR(1);
	DECLARE varOficial			CHAR(1);
	DECLARE	numActCliente		INT;


	DECLARE	NumeroCliente		INT;
	DECLARE	NombreComplet		VARCHAR(200);
	DECLARE	Fecha_Alta			DATE;
	DECLARE  Valida_RFC			CHAR(13);
	DECLARE  Var_RFCOficial		CHAR(13);
	DECLARE  Var_ActBMX			VARCHAR(15);
	DECLARE Var_Control             VARCHAR(200);
	DECLARE	Var_Consecutivo		    INT(11);


	DECLARE varTipoDirecID		INT(11);
	DECLARE varEstadoID			INT(11);
	DECLARE varMunicipioID		INT(11);
	DECLARE varCalle			VARCHAR(50);
	DECLARE varNumeroExt		CHAR(10);
	DECLARE varNumInterior		CHAR(10);
	DECLARE varColonia 			VARCHAR(50);
	DECLARE varCP 				CHAR(5);
	DECLARE varLatitud			VARCHAR(45);
	DECLARE varLongitud			VARCHAR(45);
	DECLARE varManzana			CHAR(10);
	DECLARE TipoOperaAlt		INT;
	DECLARE Var_PaisID			INT;
	DECLARE Var_LocalidadID		INT;
	DECLARE Var_ColoniaID		INT;
	DECLARE Par_ClienteID 		INT;
	DECLARE VarParentescoTutor 	INT;
	DECLARE VarParentescoMenor 	INT;
	DECLARE VarTipoRelacion  	INT;
	DECLARE Var_Relacion    	INT;
	DECLARE VarSocio       		INT;
	DECLARE Par_RegistroHacienda CHAR(1);

	DECLARE Var_AnioAct 		INT;
	DECLARE Var_MesAct  		INT;
	DECLARE Var_DiaAct  		INT;
	DECLARE Var_AnioNac 		INT;
	DECLARE Var_MesNac  		INT;
	DECLARE Var_DiaNac  		INT;
	DECLARE Var_Anios   		INT;
	DECLARE Valida_CURP			CHAR(18);
	DECLARE MenorEdad			CHAR(1);

    DECLARE ClienteSafi			INT(11);
    DECLARE NumCliSofiExpress	INT(11);
    DECLARE SiPagaISR			CHAR(1);
    DECLARE SiPagaIVA			CHAR(1);

	SET	Estatus_Activo			:='A';
	SET	Cadena_Vacia			:='';
	SET	Fecha_Vacia				:='1900-01-01';
	SET	Entero_Cero				:=	0;
	SET	PaisMex					:=700;
	SET	Salida_SI 	    		:='S';
	SET	Salida_NO 	     		:='N';
	SET	varOficial 	     		:='S';
	SET	numActCliente	  		:=  1;
	SET	TipoOperaAlt			:= 10;
	SET var_PaisID				:=  0;
	SET VarParentescoTutor		:= 40;
	SET VarParentescoMenor		:= 41;
	SET VarTipoRelacion   		:=	1;

	SET	NumeroCliente			:= 0;
	SET	NombreComplet			:='';
	SET	Per_Fisica				:='F';
	SET	Per_ActEmp				:='A';
	SET	Per_Moral				:='M';
	SET	Var_ActBMX				:='';
	SET Par_RegistroHacienda	:='N';
	SET MenorEdad				:='S';

    SET NumCliSofiExpress		:= 15;		-- Numero de cliente safi para SofiExpress
    SET SiPagaISR				:= 'S';		-- Descripcion Si ParaISR
    SET SiPagaIVA				:= 'S';		-- Descripcion Si ParaIVA

 ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := concat('El SAFI ha tenido un problema al
							  concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-SOCIOMENORALT');
		END;

		SET Par_PrimerNom      := rtrim(ltrim(ifnull(Par_PrimerNom, Cadena_Vacia)));
		SET Par_SegundoNom     := rtrim(ltrim(ifnull(Par_SegundoNom, Cadena_Vacia)));
		SET Par_TercerNom      := rtrim(ltrim(ifnull(Par_TercerNom, Cadena_Vacia)));
		SET Par_ApellidoPat    := rtrim(ltrim(ifnull(Par_ApellidoPat, Cadena_Vacia)));
		SET Par_ApellidoMat	   := rtrim(ltrim(ifnull(Par_ApellidoMat, Cadena_Vacia)));

		IF (Par_CURP != Cadena_Vacia)then
			SET Valida_CURP:=(SELECT  CURP from CLIENTES where CURP = Par_CURP  and EsMenorEdad='S');

			   IF (Valida_CURP = Par_CURP)then
					IF (Par_Salida = Salida_SI) then
						SET Par_NumErr := 	25;
						SET Par_ErrMen := 'CURP Asociada a otro safilocale.cliente Menor' ;
						SET Var_Control	:= 'CURP';
						SET Var_Consecutivo :=NumeroCliente;
						LEAVE ManejoErrores;
					ELSE
						SET	Par_NumErr := 1;
						SET	Par_ErrMen := 'CURP Asociada a otro safilocale.cliente Menor';
						LEAVE ManejoErrores;
					END IF;
				END IF;
		END IF;

		IF(ifnull(Par_SucursalOri, Entero_Cero))= Entero_Cero then
			IF (Par_Salida = Salida_SI) then
					  SET Par_NumErr :=1;
					  SET Par_ErrMen  := 'La sucursal esta Vacia.';
					  SET Var_Control := 'SucursalOri';
					  SET Var_Consecutivo :=NumeroCliente;
					  LEAVE ManejoErrores;
			ELSE
				SET	Par_NumErr := 2;
				SET	Par_ErrMen := 'La sucursal esta Vacia.' ;
				LEAVE ManejoErrores;

			END IF;
			LEAVE TerminaStore;
		END IF;

		IF(ifnull(Par_PrimerNom, Cadena_Vacia)) = Cadena_Vacia then
			IF (Par_Salida = Salida_SI) then
				SET Par_NumErr :=3;
				SET Par_ErrMen  :='El Primer Nombre esta Vacio.';
				SET Var_Control := 'PrimerNom';
				SET Var_Consecutivo :=NumeroCliente;
			LEAVE ManejoErrores;

		ELSE
				SET	Par_NumErr := 3;
				SET	Par_ErrMen := 'El Primer Nombre esta Vacio.' ;
				LEAVE ManejoErrores;

			END IF;
		END IF;


		IF(ifnull(Par_ApellidoPat, Cadena_Vacia)) = Cadena_Vacia then
			IF (Par_Salida = Salida_SI) then
				SET Par_NumErr :=4;
				SET Par_ErrMen  := 'El Apellido Paterno esta Vacio.';
				SET Var_Control := 'ApellidoPat';
				SET Var_Consecutivo :=NumeroCliente;
			LEAVE ManejoErrores;
		ELSE
				SET	Par_NumErr := 4;
				SET	Par_ErrMen := 'El Apellido Paterno esta Vacio.' ;
				LEAVE ManejoErrores;
			 END IF;
		END IF;

		IF(Par_LugarNac = PaisMex) then
			IF(ifnull(Par_estadoID, Entero_Cero))= Entero_Cero then
				IF (Par_Salida = Salida_SI) then
					SET Par_NumErr :=5;
					SET Par_ErrMen  :='El Estado esta Vacio.';
					SET Var_Control :='estadoID';
					SET Var_Consecutivo :=NumeroCliente;
					LEAVE ManejoErrores;
				ELSE
					SET	Par_NumErr := 5;
					SET	Par_ErrMen := 'El Estado esta Vacio.' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF(ifnull(Par_Nacion, Cadena_Vacia)) = Cadena_Vacia then
			IF (Par_Salida = Salida_SI) then
				SET Par_NumErr :=6;
				SET Par_ErrMen :='La Nacionalidad esta Vacia.';
				SET Var_Control :='nacion';
				SET Var_Consecutivo :=NumeroCliente;
			LEAVE ManejoErrores;
		 ELSE
				SET	Par_NumErr := 6;
				SET	Par_ErrMen := 'La Nacionalidad esta Vacia.' ;
				LEAVE ManejoErrores;

			END IF;
		END IF;

		IF(ifnull(Par_LugarNac, Entero_Cero)) = Entero_Cero then
			IF (Par_Salida = Salida_SI) then
				SET Par_NumErr :=7;
				SET Par_ErrMen :='El pais de Lugar de nacimiento esta Vacio.';
				SET Var_Control :='lugarNacimiento';
				SET Var_Consecutivo :=NumeroCliente;
				LEAVE ManejoErrores;
			ELSE
				SET	Par_NumErr := 7;
				SET	Par_ErrMen := 'el pais especificado no existe' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(ifnull(Par_LugarNac, Entero_Cero))<> Entero_Cero then
			SELECT PaisID into Var_PaisID from PAISES where PaisID = Par_LugarNac;
			IF(ifnull(Var_PaisID, Entero_Cero))= Entero_Cero then
				IF (Par_Salida = Salida_SI) then
					SET Par_NumErr :=8;
					SET Par_ErrMen :='El pais especificado como el Lugar de Nacimiento no existe.';
					SET Var_Control :='lugarNac';
					SET Var_Consecutivo :=NumeroCliente;
					LEAVE ManejoErrores;
				ELSE
					SET	Par_NumErr := 8;
					SET	Par_ErrMen := 'el pais especificado no existe' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF(ifnull(Par_PaisResi, Entero_Cero)) = Entero_Cero then
			IF (Par_Salida = Salida_SI) then
				SET Par_NumErr :=9;
				SET Par_ErrMen :='El pais de Residencia esta Vacio.';
				SET Var_Control :='paisResidencia';
				SET Var_Consecutivo :=NumeroCliente;
				LEAVE ManejoErrores;
			ELSE
				SET	Par_NumErr := 9;
				SET	Par_ErrMen := 'El pais de Residencia esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_TipoPersona=Per_Fisica or Par_TipoPersona= Per_ActEmp) then
			IF(ifnull(Par_Sexo, Cadena_Vacia)) = Cadena_Vacia then
				IF (Par_Salida = Salida_SI) then
					SET Par_NumErr :=10;
					SET Par_ErrMen :='El Sexo esta Vacio.';
					SET Var_Control :='sexo';
					SET Var_Consecutivo :=NumeroCliente;
					LEAVE ManejoErrores;
				ELSE
					SET	Par_NumErr := 10;
					SET	Par_ErrMen := 'El Sexo esta Vacio.' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF(ifnull(Par_MotivoApert, Cadena_Vacia)) = Cadena_Vacia then
			IF (Par_Salida = Salida_SI) then
				SET Par_NumErr :=11;
				SET Par_ErrMen :='EL motivo de Apertura esta Vacio.';
				SET Var_Control :='motivoApertura';
				SET Var_Consecutivo :=NumeroCliente;
				LEAVE ManejoErrores;
			ELSE
				SET	Par_NumErr := 11;
				SET	Par_ErrMen := 'EL motivo de Apertura esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(ifnull(Par_PagaISR, Cadena_Vacia)) = Cadena_Vacia then
			IF (Par_Salida = Salida_SI) then
				SET Par_NumErr :=16;
				SET Par_ErrMen :='El ISR esta Vacio.';
				SET Var_Control :='pagaISR';
				SET Var_Consecutivo :=NumeroCliente;
				LEAVE ManejoErrores;
			ELSE
				SET	Par_NumErr := 12;
				SET	Par_ErrMen := 'El ISR esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(ifnull(Par_PagaIVA, Cadena_Vacia)) = Cadena_Vacia then
			IF (Par_Salida = Salida_SI) then
				SET Par_NumErr :=17;
				SET Par_ErrMen :='El IVA esta Vacio.';
				SET Var_Control :='pagaIVA';
				SET Var_Consecutivo :=NumeroCliente;
				LEAVE ManejoErrores;
			ELSE
				SET	Par_NumErr := 13;
				SET	Par_ErrMen := 'El IVA esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(ifnull(Par_PagaIDE, Cadena_Vacia)) = Cadena_Vacia then
			IF (Par_Salida = Salida_SI) then
				SET Par_NumErr :=18;
				SET Par_ErrMen :='El IDE esta Vacio.';
				SET Var_Control :='pagaIDE';
				SET Var_Consecutivo :=NumeroCliente;
				LEAVE ManejoErrores;
			ELSE
				SET	Par_NumErr := 14;
				SET	Par_ErrMen := 'El IDE esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(ifnull(Par_NivelRiesgo, Cadena_Vacia)) = Cadena_Vacia then
			IF (Par_Salida = Salida_SI) then
				SET Par_NumErr :=19;
				SET Par_ErrMen :='El Nivel de Riesgo esta Vacio.';
				SET Var_Control :='nivelRiesgo';
				SET Var_Consecutivo :=NumeroCliente;
				LEAVE ManejoErrores;
			ELSE
				SET	Par_NumErr := 15;
				SET	Par_ErrMen := 'El Nivel de Riesgo esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_GrupoEmp 	:= ifnull(Par_GrupoEmp, Entero_Cero);
		SET Par_OcupacionID := ifnull(	Par_OcupacionID, Entero_Cero);

		IF(ifnull(Par_PromotorIni, Entero_Cero)) = Entero_Cero then
			  IF (Par_Salida = Salida_SI) then
				SET Par_NumErr :=22;
				SET Par_ErrMen :='El Promotor Inicial esta Vacio.';
				SET Var_Control :='promotorInicial';
				SET Var_Consecutivo :=NumeroCliente;
				LEAVE ManejoErrores;
			ELSE
				SET	Par_NumErr := 16;
				SET	Par_ErrMen := 'El Promotor Inicial esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(ifnull(Par_PromotorActual, Entero_Cero)) = Entero_Cero then
			IF (Par_Salida = Salida_SI) then
				SET Par_NumErr :=22;
				SET Par_ErrMen :='El Promotor Actual esta Vacio.';
				SET Var_Control :='promotorActual';
				SET Var_Consecutivo :=NumeroCliente;
				LEAVE ManejoErrores;
			ELSE
				SET	Par_NumErr := 17;
				SET	Par_ErrMen := 'El Promotor Actual esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(ifnull(Par_Telefono , Cadena_Vacia))= Cadena_Vacia then
			SET   Par_Telefono      := '0';
		END IF;


		SET Fecha_Alta:= (SELECT FechaSistema
			from PARAMETROSSIS
				where EmpresaID=1);

		IF(ifnull(Par_FechaNac, Cadena_Vacia) = Cadena_Vacia) then
			IF (Par_Salida = Salida_SI) then
				SET Par_NumErr :=33;
				SET Par_ErrMen :='Se Requiere la Fecha de Nacimiento';
				SET Var_Control :='fechaNacimiento';
				SET Var_Consecutivo :=NumeroCliente;
				LEAVE ManejoErrores;
			ELSE
				SET	Par_NumErr := 18;
				SET	Par_ErrMen := 'Se Requiere la Fecha de Nacimiento.' ;
				LEAVE ManejoErrores;
			END IF;
		ELSE
			SET Var_AnioAct := year(Fecha_Alta);
			SET Var_MesAct  := month(Fecha_Alta);
			SET Var_DiaAct  := day(Fecha_Alta);
			SET Var_AnioNac := year(Par_FechaNac);
			SET Var_MesNac  := month(Par_FechaNac);
			SET Var_DiaNac  := day(Par_FechaNac);
			SET Var_Anios 	:= Var_AnioAct-Var_AnioNac;

			IF(Var_MesAct<Var_MesNac) then
				SET Var_Anios := Var_Anios-1;
			END IF;

			IF(Var_MesAct = Var_MesNac)then
				IF(Var_DiaAct<Var_DiaNac) then
					SET Var_Anios := Var_Anios-1;
				END IF;
			END IF;
			IF (Var_Anios >= 18) then
				IF (Par_Salida = Salida_SI) then
					SET Par_NumErr :=34;
					SET Par_ErrMen :='El safilocale.cliente es Mayor de Edad, Registrarlo en la Pantalla Correspondiente';
					SET Var_Control :='fechaNacimiento';
					SET Var_Consecutivo :=NumeroCliente;
					LEAVE ManejoErrores;
				ELSE
					SET	Par_NumErr := 19;
					SET	Par_ErrMen := 'El safilocale.cliente es Mayor de Edad, Registrarlo en la Pantalla Correspondiente.' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

        -- Obtiene el numero de cliente SAFI
        SET ClienteSafi = (SELECT ValorParametro
								FROM PARAMGENERALES
                                WHERE LlaveParametro='CliProcEspecifico');
		-- Para SofiExpress todos sus clientes nacen con PagaISR y PagaIVA en S sin importan si son menores
		IF (ClienteSafi=NumCliSofiExpress) THEN
			SET Par_PagaISR = SiPagaISR;
            SET Par_PagaIVA = SiPagaIVA;
        END IF;
        -- END cambio solo para SofiExpress

		-- Se modifica el llamado para incluir un parametro de entrada. Cardinal Sistemas Inteligentes
		CALL CLIENTESALT (
			Par_SucursalOri,	Par_TipoPersona,	Par_Titulo,				Par_PrimerNom,			Par_SegundoNom,
			Par_TercerNom,		Par_ApellidoPat,	Par_ApellidoMat,		Par_FechaNac,			Par_LugarNac,
			Par_estadoID,		Par_Nacion,			Par_PaisResi,			Par_Sexo,				Par_CURP,
			Par_RFC,			Par_EstadoCivil,	Par_TelefonoCel,		Par_Telefono,			Par_Correo,
			Par_RazonSocial,	Par_TipoSocID,		Par_RFCpm,				Par_GrupoEmp,			Par_Fax,
			Par_OcupacionID,	Par_Puesto,			Par_LugardeTrab,		Par_AntTra,				Cadena_Vacia,
			Par_TelTrabajo,		Par_Clasific,		Par_MotivoApert,		Par_PagaISR,			Par_PagaIVA,
			Par_PagaIDE,		Par_NivelRiesgo,	Par_SecGeneral,			Par_ActBancoMX,			Par_ActINEGI,
			Par_SecEconomic,	Par_ActFR,			Par_ActFOMUR,			Par_PromotorIni,		Par_PromotorActual,
			Par_ProspectoID,	Par_EsMenorEdad,	Entero_Cero,			Par_RegistroHacienda,	Entero_Cero,
			Entero_Cero,		Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,			Par_ExtTelefonoPart,
			Cadena_Vacia,		Par_EjecutivoCap,	Par_PromotorExtInv,		Entero_Cero,			Fecha_Vacia,
			Entero_Cero,		Cadena_Vacia,		Entero_Cero,			Fecha_Vacia,			Entero_Cero,
			Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,			Cadena_Vacia,			Cadena_Vacia,
			Par_LugarNac,		Par_EmpresaID,		Salida_NO,				Par_NumErr,				Par_ErrMen,
			Par_ClienteID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion
		);
		-- Fin de modificacion del llamado a CLIENTESALT. Cardinal Sistemas Inteligentes

		IF(IFNULL(Par_NumErr,Entero_Cero) <> Entero_Cero)THEN
			SET Var_Control :='';
			SET Var_Consecutivo :=NumeroCliente;
			LEAVE ManejoErrores;
		END IF;

		call FOLIOSAPLICAACT('SOCIOMENOR', VarSocio);

		INSERT INTO SOCIOMENOR
			(`IDSocio`, 		`SocioMenorID`,     `ClienteTutorID`,   `NombreTutor`,	 `EjecutivoCap`,
            `PromotorExtInv`,   `EmpresaID`,		`Usuario`, 			`FechaActual`,   `DireccionIP`,
            `ProgramaID`,    	`Sucursal`,			`NumTransaccion`,	`TipoRelacionID`)
		VALUES
			(VarSocio, 				Par_ClienteID,  	Par_ClienteTutorID, 	Par_NombreTutor, 	Par_EjecutivoCap,
			Par_PromotorExtInv,  	Par_EmpresaID,		Aud_Usuario,   		 	Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,    		Aud_Sucursal,  		Aud_NumTransaccion,		Par_ParentescoID	);

		IF (ifnull(Par_ClienteTutorID, Entero_Cero)) != Entero_Cero then

			call FOLIOSAPLICAACT('RELACIONCLIEMPLEADO', Var_Relacion);

			INSERT INTO RELACIONCLIEMPLEADO
				(`RelacionID`,   `ClienteID`,    `RelacionadoID`,    `ParentescoID`, `TipoRelacion`,
				`EmpresaID`,    `Usuario`,      `FechaActual`,      `DireccionIP`,  `ProgramaID`,
				`Sucursal`,     `NumTransaccion`)
			VALUES
				(Var_Relacion,   Par_ClienteID,  	Par_ClienteTutorID, Par_ParentescoID,    VarTipoRelacion,
				Par_EmpresaID,   Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,     Aud_ProgramaID,
                Aud_Sucursal,    Aud_NumTransaccion);

			call FOLIOSAPLICAACT('RELACIONCLIEMPLEADO', Var_Relacion);

			INSERT INTO RELACIONCLIEMPLEADO
				(`RelacionID`,  `ClienteID`,    `RelacionadoID`,    `ParentescoID`, `TipoRelacion`,
				`EmpresaID`,    `Usuario`,      `FechaActual`,      `DireccionIP`,  `ProgramaID`,
				`Sucursal`,     `NumTransaccion`)
			VALUES
				(Var_Relacion,   Par_ClienteTutorID,	Par_ClienteID,   	VarParentescoMenor,   	VarTipoRelacion,
				Par_EmpresaID,   Aud_Usuario,        	Aud_FechaActual,    Aud_DireccionIP,    	Aud_ProgramaID,
                Aud_Sucursal,    Aud_NumTransaccion);
		END IF;

		SET Par_NumErr 		:= '000';
		SET Par_ErrMen 		:= CONCAT('Socio Menor Agregado Exitosamente: ',CAST(Par_ClienteID AS CHAR) );
		SET Var_Control		:= 'numero';
		SET Var_Consecutivo	:= (SELECT LPAD(Par_ClienteID, 10, 0));

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$