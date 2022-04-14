package sms.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;
import sms.bean.ResumenActividadSMSBean;


public class ResumenActividadSMSDAO  extends BaseDAO  {
	
	public ResumenActividadSMSDAO() {
		super();
	}
	

	// Lista para grid de resumen de actividad
	public List listaResumenAct(ResumenActividadSMSBean resumenActividadSMSBean, int tipoLista){
		String query = "call SMSENVIOMENSAJELIS(?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	
								Utileria.convierteEntero(resumenActividadSMSBean.getCampaniaID()),
								Constantes.STRING_VACIO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								tipoLista,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SMSENVIOMENSAJELIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				ResumenActividadSMSBean resumenActividadSMSBean = new ResumenActividadSMSBean();
				resumenActividadSMSBean.setEstatus(resultSet.getString(1));
				resumenActividadSMSBean.setNumero(String.valueOf(resultSet.getInt(2)));
				resumenActividadSMSBean.setPorcentaje(resultSet.getString(3));
				resumenActividadSMSBean.setProgramados(String.valueOf(resultSet.getInt(4)));
				resumenActividadSMSBean.setTotalEnviados(String.valueOf(resultSet.getInt(5)));
	
				return resumenActividadSMSBean;
			}
		});
		return matches;
	}

}
