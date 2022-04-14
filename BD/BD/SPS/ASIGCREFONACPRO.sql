-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASIGCREFONACPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ASIGCREFONACPRO`;DELIMITER $$

CREATE PROCEDURE `ASIGCREFONACPRO`(
	Par_InstitutFondID		INT(11),
	Par_LineaFondeoID		INT(11),
	Par_CreditoID			BIGINT(12),
	Par_FechaAsig    		DATE,
	Par_CantidadIntegrar  	DECIMAL(14,2),
	Par_TipoConsulta	 	INT(1),

	Par_EmpresaID      	 	INT(11),
	Aud_Usuario         	INT(11),
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
	)
TerminaStore: BEGIN

/*Declaracion de constantes */
DECLARE Entero_Cero      INT(1);
DECLARE Principal			INT(1);
DECLARE Foranea			   INT(1);
DECLARE Oficial          CHAR(1);
DECLARE Indistinto       CHAR(1);
DECLARE Masculino        CHAR(1);
DECLARE Femenino         CHAR(1);
DECLARE	Est_Vigente		CHAR(1);
DECLARE	Est_Vencido		CHAR(1);
DECLARE	Est_Pagado		CHAR(1);
DECLARE	Var_Condiciones	VARCHAR(100);
DECLARE Manual           CHAR(1);
DECLARE Automatico       CHAR(1);

/*Declaracion de variables */
DECLARE Var_Sexo         CHAR(1);
DECLARE Var_SalCredFon   DECIMAL(12,2);
DECLARE Var_FechaInCred  DATE;
DECLARE Var_DiasGraIng   INT(2);
DECLARE Var_FecInCred    DATE;
DECLARE Var_MaxDiasmora  INT(11);
DECLARE Var_FecInCredVen DATE;
DECLARE Var_DesCre       INT(11);
DECLARE Var_ActBmx       INT(11);
DECLARE Var_FechaSis     DATE;
DECLARE Var_Clasificacion CHAR(1);
DECLARE NoAplica         CHAR(1);

-- Variables del cursor CURSORFONDEOEDO
DECLARE Var_EstadoID		INT(11);
DECLARE Var_MunicipioID	INT(11);
DECLARE Var_LocalidadID	INT(11);
DECLARE Var_NumHabitaInf  INT(11);
DECLARE Var_NumHabitaSup  INT(11);

-- Variables del cursor final CURSORREDESCUEN
DECLARE SumSaldCapCred           INT(11);
DECLARE Var_FormaSel             CHAR(1);
DECLARE Var_CredID               INT(11);
DECLARE Var_NomClie              VARCHAR(200);
DECLARE Var_FeIni                DATE;
DECLARE Var_FeVen                DATE;
DECLARE Var_MontCred             DECIMAL(12,2);
DECLARE Var_SalCap               DECIMAL(12,2);
DECLARE Var_TipPer               VARCHAR(15);
DECLARE Var_ProdCred             VARCHAR(100);
DECLARE Var_DirCom               VARCHAR(500);
DECLARE Var_DiasAtraso           INT(11);

/*Declaracion del cursor para las condiciones de descuento por estado, municipio, localidad y numero de habitantes */
DECLARE CURSORFONDEOEDO CURSOR FOR
SELECT EstadoID,MunicipioID,LocalidadID,NumHabitantesInf,NumHabitantesSup FROM LINFONCONDEDO WHERE LineaFondeoID = Par_LineaFondeoID;
/*Fin del cursor */

/*Declaracion del cursor para listar los creditos manuales de la linea de fondeo y los generados automaticamente con las condiciones de descuento */
DECLARE CURSORREDESCUEN CURSOR FOR
(SELECT Cf.FormaSeleccion,Cr.CreditoID,Cl.NombreCompleto,Cr.FechaInicio,Cr.FechaVencimien,Cr.MontoCredito,(Cr.SaldoCapVigent+Cr.SaldoCapAtrasad+Cr.SaldoCapVencido+Cr.SaldCapVenNoExi) AS SaldoCapital,
       CASE Cl.TipoPersona WHEN 'F' THEN 'FISICA'
            WHEN 'M' THEN 'MORAL'
            WHEN 'A' THEN 'FISICA ACT. EMP'
            END	AS TIPO, Pr.Descripcion,Dir.DireccionCompleta,IFNULL((DATEDIFF(Var_FechaSis,MIN(Amo.FechaExigible))),Entero_Cero) AS DiasAtraso
FROM CREDITOS Cr
INNER JOIN CLIENTES AS Cl
            ON Cr.ClienteID = Cl.ClienteID
INNER  JOIN DIRECCLIENTE AS Dir
            ON  Dir.ClienteID = Cl.ClienteID
            AND Dir.Oficial = Oficial
INNER JOIN PRODUCTOSCREDITO AS Pr
            ON  Cr.ProductoCreditoID = Pr.ProducCreditoID
LEFT JOIN AMORTICREDITO AS Amo
                    ON   Cr.CreditoID = Amo.CreditoID
                    AND Amo.FechaExigible <= Var_FechaSis
                    AND Amo.Estatus       !=  Est_Pagado
INNER JOIN CREDITOFONDEOASIG AS Cf
            ON  Cr.CreditoID = Cf.CreditoID
            AND Cf.InstitutFondeoID = Par_InstitutFondID
            AND Cf.LineaFondeoID = Par_LineaFondeoID
            AND Cf.CreditoFondeoID = Par_CreditoID
            AND Cf.FechaAsignacion = Par_FechaAsig
            AND Cf.FormaSeleccion = Manual)
UNION ALL
(SELECT FormaSeleccion,CreditoID,NombreCliente,FechaInicio,FechaVencim,MontoCredito,SaldoCapital,
 TipoPersona,ProductoCredito,DireccionCompleta,DiasAtraso FROM TMPCREDFONDAS);
/*Fin del cursor */

/*Declaracion de constantes */
SET Entero_Cero       :=0;
SET Principal			:= 1;
SET Foranea           := 2;
SET Oficial           :='S';
SET Indistinto        :='I';
SET Masculino         :='M';
SET Femenino          :='F';
SET Est_Vigente	 	   := 'V';
SET Est_Vencido	     	:= 'B';
SET Est_Pagado	     	:= 'P';
SET Manual            := 'M';
SET Automatico        := 'A';
SET SumSaldCapCred    := 0;
SET Var_Condiciones     := '';
SET NoAplica          := 'N';

/* -------------- CONSULTA PRINCIPAL  -------------- */

IF(Par_TipoConsulta = Principal) THEN

    TRUNCATE TMPCREDFONDAS;
    TRUNCATE TMPCREDFONASIG;

    SELECT FechaSistema INTO Var_FechaSis
        FROM PARAMETROSSIS;

    /* -------------- Llamada a los SP para consultar las condiciones de descuento del cliente para el estado civil y producto de credito  -------------- */
    CALL FONDEADORESDOCIVIL(Par_LineaFondeoID);
    CALL FONDEADORPRODCRE(Par_LineaFondeoID);

    /* ---- Consulta para obtener el saldo del credito pasivo y calcular la fecha de inicio de los creditos activos ---- */
    SELECT Lc.DiasGraIngCre , Crf.fechaInicio ,Lc.MaxDiasMora INTO Var_DiasGraIng, Var_FechaInCred, Var_MaxDiasmora
    FROM CREDITOFONDEO Crf,
         LINFONCONDCTE Lc

    WHERE Crf.CreditoFondeoID=Par_CreditoID
    AND   Crf.LineaFondeoID=Par_LineaFondeoID
    AND   Crf.InstitutFondID=Par_InstitutFondID
    AND   Crf.LineaFondeoID=Lc.LineaFondeoID;

    SET Var_FecInCred := DATE_ADD(Var_FechaInCred, INTERVAL -Var_DiasGraIng DAY);
    /* -- Fin de la consulta-- */

    /* ----- Consulta para las condiciones de descuento del cliente para obtener el sexo de la linea de fondeo ----- */
    SELECT Sexo INTO Var_Sexo FROM LINFONCONDCTE WHERE LineaFondeoID = Par_LineaFondeoID;
    /* ----- Consulta para obtener la clasificaciÃ³n del destino de credito */
    SELECT Clasificacion INTO Var_Clasificacion FROM LINFONCONDCTE WHERE LineaFondeoID = Par_LineaFondeoID;
    /* ----- Consulta para verificar si existen condiciones de descuento de destino de credito de la linea de fondeo ----- */
    SET Var_DesCre := IFNULL((SELECT COUNT(DestinoCreID) FROM LINFONCONDDEST WHERE LineaFondeoID = Par_LineaFondeoID),Entero_Cero);
    /* ----- Consulta para verificar si existen condiciones de descuento de ActividadBMX de la linea de fondeo ----- */
    SET Var_ActBmx := IFNULL((SELECT COUNT(ActividadBMXID) FROM  LINFONCONDACT WHERE LineaFondeoID = Par_LineaFondeoID),Entero_Cero);

    /* Se insertan los registro en la tabla  TMPCREDFONASIG dependiendo del sexo, si existen Condiciones de Destino de Credito y ActividadBMX */
    CALL TMPCREDFONASIGALT(Par_LineaFondeoID,Par_FechaAsig,Var_FecInCred,Var_Sexo,Var_DesCre,Var_ActBmx,Var_Clasificacion,Principal);

    /* Se abre el cursor para las condiciones de descuento dependiendo del estado, municipio, localidad y numero de habitantes */
    OPEN CURSORFONDEOEDO;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP

         /* se insertan los registros que cumplan con las condiciones en la tabla TMPCREDFONDAS  */
         FETCH CURSORFONDEOEDO INTO Var_EstadoID,Var_MunicipioID,Var_LocalidadID,Var_NumHabitaInf,Var_NumHabitaSup;
         IF (Var_EstadoID = Entero_Cero) THEN
         INSERT INTO TMPCREDFONDAS (FormaSeleccion,CreditoID,NombreCliente,FechaInicio,FechaVencim,MontoCredito,SaldoCapital,
                                    TipoPersona,ProductoCredito,DireccionCompleta,DiasAtraso)
                                    SELECT Tmp.FormaSeleccion,Tmp.CreditoID,Tmp.NombreCliente,Tmp.FechaInicio,Tmp.FechaVencim,Tmp.MontoCredito,Tmp.SaldoCapital,
                                    Tmp.TipoPersona,Tmp.ProductoCredito,Tmp.DireccionCompleta,Tmp.DiasMora FROM TMPCREDFONASIG AS Tmp
                                    WHERE (SELECT IFNULL(SUM(Loc.NumHabitantes),Entero_Cero) FROM MUNICIPIOSREPUB Mun INNER JOIN LOCALIDADREPUB Loc ON Loc.MunicipioID=Mun.MunicipioID
                                           AND Loc.EstadoID = Mun.EstadoID WHERE Mun.EstadoID	= Tmp.EstadoID AND Mun.MunicipioID	= Tmp.MunicipioID) >= Var_NumHabitaInf
                                    AND (SELECT IFNULL(SUM(Loc.NumHabitantes),Entero_Cero) FROM MUNICIPIOSREPUB Mun INNER JOIN LOCALIDADREPUB Loc ON Loc.MunicipioID=Mun.MunicipioID
                                           AND Loc.EstadoID = Mun.EstadoID WHERE Mun.EstadoID	= Tmp.EstadoID AND Mun.MunicipioID	= Tmp.MunicipioID) <= Var_NumHabitaSup
                                    AND Tmp.DiasMora <= Var_MaxDiasMora;

         ELSE IF (Var_MunicipioID = Entero_Cero) THEN
         INSERT INTO TMPCREDFONDAS (FormaSeleccion,CreditoID,NombreCliente,FechaInicio,FechaVencim,MontoCredito,SaldoCapital,
                                    TipoPersona,ProductoCredito,DireccionCompleta,DiasAtraso)
                                    SELECT Tmp.FormaSeleccion,Tmp.CreditoID,Tmp.NombreCliente,Tmp.FechaInicio,Tmp.FechaVencim,Tmp.MontoCredito,Tmp.SaldoCapital,
                                    Tmp.TipoPersona,Tmp.ProductoCredito,Tmp.DireccionCompleta,Tmp.DiasMora FROM TMPCREDFONASIG AS Tmp
                                    WHERE Tmp.EstadoID = Var_EstadoID
                                    AND (SELECT IFNULL(SUM(Loc.NumHabitantes),Entero_Cero) FROM MUNICIPIOSREPUB Mun INNER JOIN LOCALIDADREPUB Loc ON Loc.MunicipioID=Mun.MunicipioID
                                           AND Loc.EstadoID = Mun.EstadoID WHERE Mun.EstadoID	= Tmp.EstadoID AND Mun.MunicipioID	= Tmp.MunicipioID) >= Var_NumHabitaInf
                                    AND (SELECT IFNULL(SUM(Loc.NumHabitantes),Entero_Cero) FROM MUNICIPIOSREPUB Mun INNER JOIN LOCALIDADREPUB Loc ON Loc.MunicipioID=Mun.MunicipioID
                                           AND Loc.EstadoID = Mun.EstadoID WHERE Mun.EstadoID	= Tmp.EstadoID AND Mun.MunicipioID	= Tmp.MunicipioID) <= Var_NumHabitaSup
                                    AND Tmp.DiasMora <= Var_MaxDiasMora;

                    ELSE IF (Var_LocalidadID = Entero_Cero) THEN
                    INSERT INTO TMPCREDFONDAS (FormaSeleccion,CreditoID,NombreCliente,FechaInicio,FechaVencim,MontoCredito,SaldoCapital,
                                    TipoPersona,ProductoCredito,DireccionCompleta,DiasAtraso)
                                    SELECT Tmp.FormaSeleccion,Tmp.CreditoID,Tmp.NombreCliente,Tmp.FechaInicio,Tmp.FechaVencim,Tmp.MontoCredito,Tmp.SaldoCapital,
                                    Tmp.TipoPersona,Tmp.ProductoCredito,Tmp.DireccionCompleta,Tmp.DiasMora FROM TMPCREDFONASIG AS Tmp
                                    WHERE Tmp.EstadoID = Var_EstadoID AND Tmp.MunicipioID=Var_MunicipioID
                                    AND (SELECT IFNULL(SUM(Loc.NumHabitantes),Entero_Cero) FROM MUNICIPIOSREPUB Mun INNER JOIN LOCALIDADREPUB Loc ON Loc.MunicipioID=Mun.MunicipioID
                                           AND Loc.EstadoID = Mun.EstadoID WHERE Mun.EstadoID	= Tmp.EstadoID AND Mun.MunicipioID	= Tmp.MunicipioID) >= Var_NumHabitaInf
                                    AND (SELECT IFNULL(SUM(Loc.NumHabitantes),Entero_Cero) FROM MUNICIPIOSREPUB Mun INNER JOIN LOCALIDADREPUB Loc ON Loc.MunicipioID=Mun.MunicipioID
                                           AND Loc.EstadoID = Mun.EstadoID WHERE Mun.EstadoID	= Tmp.EstadoID AND Mun.MunicipioID	= Tmp.MunicipioID) <= Var_NumHabitaSup
                                    AND Tmp.DiasMora <= Var_MaxDiasMora;
                         ELSE
                                    INSERT INTO TMPCREDFONDAS (FormaSeleccion,CreditoID,NombreCliente,FechaInicio,FechaVencim,MontoCredito,SaldoCapital,
		                            TipoPersona,ProductoCredito,DireccionCompleta,DiasAtraso)
		                            SELECT Tmp.FormaSeleccion,Tmp.CreditoID,Tmp.NombreCliente,Tmp.FechaInicio,Tmp.FechaVencim,Tmp.MontoCredito,Tmp.SaldoCapital,
		                            Tmp.TipoPersona,Tmp.ProductoCredito,Tmp.DireccionCompleta,Tmp.DiasMora FROM TMPCREDFONASIG AS Tmp
		                            WHERE Tmp.EstadoID = Var_EstadoID AND Tmp.MunicipioID=Var_MunicipioID AND Tmp.LocalidadID=Var_LocalidadID
		                            AND (SELECT IFNULL(SUM(Loc.NumHabitantes),Entero_Cero) FROM MUNICIPIOSREPUB Mun INNER JOIN LOCALIDADREPUB Loc ON Loc.MunicipioID=Mun.MunicipioID
		                                   AND Loc.EstadoID = Mun.EstadoID WHERE Mun.EstadoID	= Tmp.EstadoID AND Mun.MunicipioID	= Tmp.MunicipioID) >= Var_NumHabitaInf
		                            AND (SELECT IFNULL(SUM(Loc.NumHabitantes),Entero_Cero) FROM MUNICIPIOSREPUB Mun INNER JOIN LOCALIDADREPUB Loc ON Loc.MunicipioID=Mun.MunicipioID
		                                   AND Loc.EstadoID = Mun.EstadoID WHERE Mun.EstadoID	= Tmp.EstadoID AND Mun.MunicipioID	= Tmp.MunicipioID) <= Var_NumHabitaSup
		                            AND Tmp.DiasMora <= Var_MaxDiasMora;
		                END IF;
		           END IF;
		      END IF;
	  END LOOP;
	END;
	CLOSE CURSORFONDEOEDO;
/* Fin del cursor */

/* Se eliminan los datos de la tabla TMPCREDFONASIG para insertar los registros que cumplieron todas las condiciones */
TRUNCATE TMPCREDFONASIG;

/* Se abre el cursor final el cual inserta en la tabla TMPCREDFONASIG los registros cuya suma no sea mayor al saldo del credito pasivo*/
OPEN CURSORREDESCUEN;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLOREDESCUENTO: LOOP

         FETCH CURSORREDESCUEN INTO Var_FormaSel,Var_CredID,Var_NomClie,Var_FeIni,Var_FeVen,Var_MontCred,Var_SalCap,Var_TipPer,Var_ProdCred,Var_DirCom,Var_DiasAtraso;

         SET SumSaldCapCred := SumSaldCapCred + Var_SalCap;

         INSERT INTO TMPCREDFONASIG (FormaSeleccion,CreditoID,NombreCliente,FechaInicio,FechaVencim,MontoCredito,SaldoCapital,
                                    TipoPersona,ProductoCredito,DireccionCompleta,DiasMora)
                                    VALUES (Var_FormaSel,Var_CredID,Var_NomClie,Var_FeIni,Var_FeVen,Var_MontCred,Var_SalCap,Var_TipPer,Var_ProdCred,Var_DirCom,Var_DiasAtraso);

         IF (SumSaldCapCred >= Par_CantidadIntegrar) THEN
         LEAVE CICLOREDESCUENTO;
         END IF;
      END LOOP;
END;
CLOSE CURSORREDESCUEN;
/* Fin del cursor*/
/* Se listan los creditos que cumplen con todas las condiciones de descuento para el credito pasivo*/

SELECT (SELECT (CASE WHEN COUNT(His.CreditoID)>0 THEN 'SI'
                      ELSE 'NO' END )
            FROM `HIS-CREDFONASIG` His
            WHERE His.CreditoID = TmpCre.CreditoID) AS PrevioReporte,
       TmpCre.FormaSeleccion,TmpCre.CreditoID,TmpCre.NombreCliente,TmpCre.FechaInicio,TmpCre.FechaVencim,
       TmpCre.MontoCredito,TmpCre.SaldoCapital,TmpCre.TipoPersona,TmpCre.ProductoCredito,TmpCre.DireccionCompleta,Cl.ClienteID,Cl.ActividadBancoMx,Act.Descripcion AS ActDescrip,
        CASE Cl.Sexo
            WHEN 'F' THEN 'FEMENINO'
            WHEN 'M' THEN 'MASCULINO'
            END	AS Sexo,
        CASE Cl.EstadoCivil
            WHEN 'S' THEN 'SOLTERO'
            WHEN 'CS' THEN 'CASADO BIENES SEPARADOS'
            WHEN 'CM' THEN 'CASADO BIENES MANCOMUNADOS'
            WHEN 'CC'THEN 'CASADO BIENES MANCUMUNADOS CON CAPITULACION'
            WHEN 'V'THEN 'VIUDO'
            WHEN 'D'THEN 'DIVORSIADO'
            WHEN 'SE' THEN 'SEPARADO'
            WHEN 'U' THEN 'UNION LIBRE'
            END	AS EstadoCivil,Cr.DestinoCreID,Dest.Descripcion AS Destino,TmpCre.DiasMora AS DiasAtraso

FROM TMPCREDFONASIG TmpCre
INNER JOIN CREDITOS AS Cr
            ON Cr.CreditoID=TmpCre.CreditoID
INNER JOIN CLIENTES AS Cl
            ON Cr.ClienteID = Cl.ClienteID
INNER  JOIN DIRECCLIENTE AS Dir
            ON  Dir.ClienteID = Cl.ClienteID
            AND Dir.Oficial = Oficial
INNER  JOIN LOCALIDADREPUB AS Loc
            ON  Loc.LocalidadID = Dir.LocalidadID
INNER JOIN PRODUCTOSCREDITO AS Pr
            ON  Cr.ProductoCreditoID = Pr.ProducCreditoID
INNER JOIN ACTIVIDADESBMX AS Act
            ON Cl.ActividadBancoMx = Act.ActividadBMXID
INNER JOIN DESTINOSCREDITO AS Dest
            ON Cr.DestinoCreID = Dest.DestinoCreID
GROUP BY TmpCre.CreditoID,		TmpCre.FormaSeleccion,	TmpCre.NombreCliente,	TmpCre.FechaInicio,		TmpCre.FechaVencim,
		 TmpCre.MontoCredito,	TmpCre.SaldoCapital,	TmpCre.TipoPersona,		TmpCre.ProductoCredito,	TmpCre.DireccionCompleta,
		 Cl.ClienteID,			Cl.ActividadBancoMx,	Act.Descripcion,		Cr.DestinoCreID,		Dest.Descripcion,
         TmpCre.DiasMora,		Cl.Sexo,				Cl.EstadoCivil
ORDER BY TmpCre.FormaSeleccion DESC;

END IF;

END TerminaStore$$