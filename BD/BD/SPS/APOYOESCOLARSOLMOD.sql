-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APOYOESCOLARSOLMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `APOYOESCOLARSOLMOD`;DELIMITER $$

CREATE PROCEDURE `APOYOESCOLARSOLMOD`(

  Par_ClienteID     INT(11),
  Par_ApoyoEscSolID   INT(11),
  Par_EdadCliente     INT(11),
  Par_ApoyoEscCicloID   INT(11),
  Par_GradoEscolar    INT(11),
  Par_PromedioEscolar   DECIMAL(12,2),
  Par_CicloEscolar    VARCHAR(50),
  Par_NombreEscuela   VARCHAR(200),
  Par_DireccionEscuela  VARCHAR(500),

  Par_Salida        CHAR(1),
  INOUT Par_NumErr    INT,
  INOUT Par_ErrMen    VARCHAR(400),


  Par_EmpresaID     INT(11),
  Aud_Usuario       INT(11),
  Aud_FechaActual     DATETIME,
  Aud_DireccionIP     VARCHAR(15),
  Aud_ProgramaID      VARCHAR(50),
  Aud_Sucursal      INT(11),
  Aud_NumTransaccion    BIGINT(20)
	)
TerminaStore:BEGIN


  DECLARE Var_ApoyoEscSolID   INT(11);
  DECLARE Var_FechaReg      DATE;
  DECLARE Var_TipoCalculo     CHAR(2);
  DECLARE Var_Monto       DECIMAL(14,2);
  DECLARE varControl          CHAR(15);
  DECLARE Var_AnioInicioValida  INT(11);
  DECLARE Var_MesInicioValida   VARCHAR(15);
  DECLARE Var_NumMesesValida    INT(12);
  DECLARE Var_CuentaValidAho    BIGINT(12);
  DECLARE Var_MontoMinimo     FLOAT(12,2);
  DECLARE Var_TipoCtaApoyoEscMay  INT(11);
  DECLARE Var_TipoCtaApoyoEscMen  INT(11);
  DECLARE Edad_Cliente      INT(11);
  DECLARE Var_Aceptable     CHAR(1);
  DECLARE Var_DescripcionCta    VARCHAR(100);



  DECLARE Estatus_Reg     CHAR(1);
  DECLARE Estatus_Activo    CHAR(1);
  DECLARE Entero_Cero     INT;
  DECLARE Decimal_Cero    DECIMAL;
  DECLARE Cadena_Vacia    CHAR(1);
  DECLARE Salida_SI     CHAR(1);
  DECLARE Con_MF        CHAR(2);
  DECLARE Con_SM        CHAR(2);
  DECLARE SalarioMinimo   DECIMAL(12,2);
  DECLARE Maryor_Edad     INT(11);
  DECLARE Si_Aceptable    CHAR(1);
  DECLARE No_Aceptable    CHAR(1);
  DECLARE Fecha_Vacia     DATE;


  SET Estatus_Reg     :='R';
  SET Estatus_Activo    :='A';
  SET Entero_Cero     :=0;
  SET Decimal_Cero    :=0.0;
  SET Cadena_Vacia    :='';
  SET Salida_SI     :='S';
  SET Con_MF        :='MF';
  SET Con_SM        :='SM';
  SET Maryor_Edad     :=18;
  SET Si_Aceptable    :='S';
  SET No_Aceptable    :='N';
  SET Fecha_Vacia     :='1900-01-01';


  SET Par_NumErr    := 0;
  SET Par_ErrMen    := '';
  SET Var_FechaReg    :=(SELECT FechaSistema FROM PARAMETROSSIS);
  SET SalarioMinimo   :=(SELECT SalMinDF FROM PARAMETROSSIS);



  ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr = '999';
        SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
                     'estamos trabajando para resolverla. Disculpe las molestias que ',
                     'esto le ocasiona. Ref: SP-APOYOESCOLARSOLMOD');
        SET varControl = 'sqlException' ;
      END;

    IF(ifnull(Par_ClienteID,Entero_Cero))= Entero_Cero THEN
      SET Par_NumErr  := '001';
      SET Par_ErrMen  := 'El ID del safilocale.cliente esta vacio.';
      SET varControl  := 'clienteID' ;
      LEAVE ManejoErrores;
    END IF;

    IF(ifnull(Par_ApoyoEscSolID,Entero_Cero))= Entero_Cero THEN
      SET Par_NumErr  := '002';
      SET Par_ErrMen  := 'El ID de la Solicitud esta vacia.';
      SET varControl  := 'apoyoEscSolID' ;
      LEAVE ManejoErrores;
    END IF;


    IF(ifnull(Par_EdadCliente,Entero_Cero))= Entero_Cero THEN
      SET Par_NumErr  := '003';
      SET Par_ErrMen  := 'La Edad del safilocale.cliente esta vacia.';
      SET varControl  := 'edadCliente' ;
      LEAVE ManejoErrores;
    END IF;

    IF(ifnull(Par_ApoyoEscCicloID,Entero_Cero))= Entero_Cero THEN
      SET Par_NumErr  := '004';
      SET Par_ErrMen  := 'El Grado Escolar esta vacio.';
      SET varControl  := 'apoyoEscCicloID' ;
      LEAVE ManejoErrores;
    END IF;

    IF(ifnull(Par_GradoEscolar,Entero_Cero))= Entero_Cero THEN
      SET Par_NumErr  := '005';
      SET Par_ErrMen  := 'El Numero de Grado Escolar esta vacio.';
      SET varControl  := 'gradoEscolar' ;
      LEAVE ManejoErrores;
    END IF;

    IF(ifnull(Par_PromedioEscolar,Decimal_Cero))= Decimal_Cero THEN
      SET Par_NumErr  := '006';
      SET Par_ErrMen  := 'El Promedio Escolar esta vacio.';
      SET varControl  := 'promedioEscolar' ;
      LEAVE ManejoErrores;
    END IF;

    IF(ifnull(Par_CicloEscolar,Cadena_Vacia))= Cadena_Vacia THEN
      SET Par_NumErr  := '007';
      SET Par_ErrMen  := 'El Ciclo Escolar esta vacio.';
      SET varControl  := 'cicloEscolar' ;
      LEAVE ManejoErrores;
    END IF;

    IF(ifnull(Par_NombreEscuela,Cadena_Vacia))= Cadena_Vacia THEN
      SET Par_NumErr  := '008';
      SET Par_ErrMen  := 'El Nombre de la Escuela esta vacio.';
      SET varControl  := 'nombreEscuela' ;
      LEAVE ManejoErrores;
    END IF;

    IF(ifnull(Par_DireccionEscuela,Cadena_Vacia))= Cadena_Vacia THEN
      SET Par_NumErr  := '009';
      SET Par_ErrMen  := 'La Direccion de la Escuela esta vacia.';
      SET varControl  := 'direccionEscuela' ;
      LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS(SELECT ApoyoEscSolID
          FROM  APOYOESCOLARSOL
          WHERE ApoyoEscSolID = Par_ApoyoEscSolID AND Estatus=Estatus_Reg)THEN
        SET Par_NumErr  := '010';
        SET Par_ErrMen  := 'No es Posible Modificar la solicitud.';
        SET varControl  := 'apoyoEscSolID' ;
        LEAVE ManejoErrores;
    END IF;
    IF NOT EXISTS(SELECT ClienteID
          FROM  CLIENTES
          WHERE ClienteID = Par_ClienteID AND Estatus=Estatus_Activo)THEN
        SET Par_NumErr  := '011';
        SET Par_ErrMen  := 'El safilocale.cliente No Existe.';
        SET varControl  := 'clienteID' ;
        LEAVE ManejoErrores;
    END IF;
    IF NOT EXISTS(SELECT A.ApoyoEscCicloID
        FROM  APOYOESCCICLO A INNER JOIN PARAMAPOYOESCOLAR PE ON A.ApoyoEscCicloID=PE.ApoyoEscCicloID
        WHERE A.ApoyoEscCicloID = Par_ApoyoEscCicloID)THEN
        SET Par_NumErr  := '012';
        SET Par_ErrMen  := 'El Grado Escolar No ha Sido Parametrizado.';
        SET varControl  := 'apoyoEscCicloID' ;
        LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS(SELECT promedioMinimo
          FROM  PARAMAPOYOESCOLAR
          WHERE PromedioMinimo <= Par_PromedioEscolar
          AND ApoyoEscCicloID =  Par_ApoyoEscCicloID)THEN
        SET Par_NumErr  := '013';
        SET Par_ErrMen  := 'El safilocale.cliente No Cumple con el Promedio Minimo.';
        SET varControl  := 'promedioEscolar' ;
        LEAVE ManejoErrores;
    END IF;

		IF EXISTS(SELECT ApoyoEscCicloID
					FROM 	APOYOESCOLARSOL
					WHERE ApoyoEscCicloID = Par_ApoyoEscCicloID AND ClienteID=Par_ClienteID
					AND   GradoEscolar = Par_GradoEscolar AND ApoyoEscSolID != Par_ApoyoEscSolID)THEN
				SET Par_NumErr  := '014';
				SET Par_ErrMen  := 'El safilocale.cliente ya tiene Registrada una Solicitud para el Grado Escolar seleccionado.';
				SET varControl  := 'apoyoEscCicloID' ;
				LEAVE ManejoErrores;
		END IF;



	   SELECT
		Par.MesInicioAhoCons,	  Apo.MesesAhorroCons,	Par.MontoMinMesApoyoEsc,  Par.TipoCtaApoyoEscMay,  Par.TipoCtaApoyoEscMen
		INTO
        Var_MesInicioValida, 	 Var_NumMesesValida,		Var_MontoMinimo,      Var_TipoCtaApoyoEscMay,	   Var_TipoCtaApoyoEscMen
        FROM PARAMETROSCAJA Par,
             PARAMAPOYOESCOLAR Apo
        WHERE Par.EmpresaID    		 = Par_EmpresaID
		AND Apo.ApoyoEscCicloID    = Par_ApoyoEscCicloID;


		SET Var_AnioInicioValida := ( SELECT YEAR (Var_FechaReg))-1;
		SET Edad_Cliente :=(SELECT (YEAR
									(Var_FechaReg)- YEAR (FechaNacimiento))
									- (RIGHT(Var_FechaReg,5)<RIGHT(FechaNacimiento,5)) AS Edad
							FROM CLIENTES WHERE ClienteID=Par_ClienteID);


		IF(Edad_Cliente >= Maryor_Edad) THEN
			SET Var_CuentaValidAho 	 := (SELECT CuentaAhoID FROM CUENTASAHO WHERE FechaApertura != Cadena_Vacia AND FechaApertura !=Fecha_Vacia
									 AND ClienteID = Par_ClienteID AND TipoCuentaID = Var_TipoCtaApoyoEscMay  ORDER BY FechaApertura ASC LIMIT 1);

			select Descripcion into Var_DescripcionCta
				from TIPOSCUENTAS WHERE TipoCuentaID = Var_TipoCtaApoyoEscMay;
		END IF;

		IF(Edad_Cliente < Maryor_Edad) THEN
			SET Var_CuentaValidAho 	 := (SELECT CuentaAhoID FROM CUENTASAHO WHERE FechaApertura != Cadena_Vacia AND FechaApertura !=Fecha_Vacia
									 AND ClienteID = Par_ClienteID AND TipoCuentaID = Var_TipoCtaApoyoEscMen  ORDER BY FechaApertura ASC LIMIT 1);

			select Descripcion into Var_DescripcionCta
				from TIPOSCUENTAS WHERE TipoCuentaID = Var_TipoCtaApoyoEscMen;
		END IF;

	set Var_DescripcionCta	:= ifnull(Var_DescripcionCta,Cadena_Vacia);

 	IF(ifnull(Var_CuentaValidAho, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr  := '017';
		SET Par_ErrMen  := concat('El safilocale.cliente no tiene una Cuenta ', Var_DescripcionCta, ' Activa');
		SET varControl  := 'clienteID' ;
		LEAVE ManejoErrores;
	END IF;


		SET Aud_FechaActual 	:= NOW();
		 CALL VALIDAAHORROPRO(Var_AnioInicioValida,  Var_MesInicioValida,   Var_NumMesesValida,  Var_CuentaValidAho,  	Var_MontoMinimo,
							  Var_Aceptable,		 Par_Salida,			Par_NumErr,			 Par_ErrMen,	 		 Par_EmpresaID,
							  Aud_Usuario,		     Aud_FechaActual,	     Aud_DireccionIP,	    Aud_ProgramaID,      Aud_Sucursal,
							  Aud_NumTransaccion );



 	  IF(Var_Aceptable = Si_Aceptable) THEN

			SET Var_TipoCalculo		:=(SELECT TipoCalculo FROM PARAMAPOYOESCOLAR WHERE ApoyoEscCicloID=Par_ApoyoEscCicloID);
			IF (Var_TipoCalculo = Con_MF) THEN
				SET Var_Monto := (SELECT Cantidad FROM PARAMAPOYOESCOLAR WHERE ApoyoEscCicloID=Par_ApoyoEscCicloID);
			ELSE
				SET Var_Monto :=SalarioMinimo * (SELECT Cantidad FROM PARAMAPOYOESCOLAR WHERE ApoyoEscCicloID=Par_ApoyoEscCicloID);
			END IF;



			SET Aud_FechaActual 	:= NOW();


			SET Aud_FechaActual := NOW();
			 UPDATE APOYOESCOLARSOL SET
							EdadCliente			= Par_EdadCliente,
							ApoyoEscCicloID		= Par_ApoyoEscCicloID,
							GradoEscolar		= Par_GradoEscolar,
							PromedioEscolar		= Par_PromedioEscolar,
							CicloEscolar		= Par_CicloEscolar,
							NombreEscuela		= Par_NombreEscuela,
							DireccionEscuela	= Par_DireccionEscuela,
							Monto				= Var_Monto,

							EmpresaID			= Par_EmpresaID,
							Usuario				= Aud_Usuario,
							FechaActual			= Aud_FechaActual,
							DireccionIP			= Aud_DireccionIP,
							ProgramaID			= Aud_ProgramaID,
							Sucursal			= Aud_Sucursal,
							NumTransaccion		= Aud_NumTransaccion
						WHERE ClienteID = Par_ClienteID AND ApoyoEscSolID=Par_ApoyoEscSolID;

				SET Par_NumErr  := '000';
				SET Par_ErrMen  := CONCAT('Solicitud de Apoyo Escolar Modificada exitosamente: ',Par_ApoyoEscSolID);
				SET varControl  := 'apoyoEscSolID' ;
				LEAVE ManejoErrores;
		ELSE
			SET Var_ApoyoEscSolID	:= Entero_Cero;
			LEAVE ManejoErrores;

	END IF;

END ManejoErrores;



	IF (Par_Salida = Salida_SI) THEN
		SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen		 	AS ErrMen,
				varControl		 	AS control,
				Par_ApoyoEscSolID	AS consecutivo;
	end IF;

END TerminaStore$$