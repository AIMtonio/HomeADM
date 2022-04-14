package soporte.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

import pld.bean.ParametrosOpRelBean;

import cuentas.bean.MonedasBean;

import soporte.bean.PlazasBean;
import soporte.bean.TipoInstrumMoneBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
 
public class TipoInstrumMoneDAO extends BaseDAO{

	
	
	//consulta tipo de Instrumento Monetario foranea
	public TipoInstrumMoneBean consultaForanea(TipoInstrumMoneBean tipoInstrum, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call INSTRUMENTOSMONCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { tipoInstrum.getInstrumentMonID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoInstrumMoneDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTRUMENTOSMONCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TipoInstrumMoneBean tipoInstrumMoneBean = new TipoInstrumMoneBean();
				tipoInstrumMoneBean.setInstrumentMonID(String.valueOf(resultSet.getInt(1))); 
				tipoInstrumMoneBean.setTipoInstruMonID(String.valueOf(resultSet.getInt(2))); 
				return tipoInstrumMoneBean;
			}
		});
		return matches.size() > 0 ? (TipoInstrumMoneBean) matches.get(0) : null;
	}
	
	//Lista de tipos de instrumentos	
	public List listaComboInstrumentos(int tipoLista) {
		
		//Query con el Store Procedure
		String query = "call TIPOINSTRUMMONELIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	"",
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoInstrumMoneDAO.listaComboInstrumentos",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOINSTRUMMONELIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				TipoInstrumMoneBean tipoInstrumMon = new TipoInstrumMoneBean();	
				
				tipoInstrumMon.setTipoInstruMonID(String.valueOf(resultSet.getString(1)));
				tipoInstrumMon.setDescripcion(resultSet.getString(2));
				return tipoInstrumMon;				
			}
		});
				
		return matches;
	}	
	
}
