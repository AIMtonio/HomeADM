package cliente.dao;

import herramientas.Constantes;
import herramientas.Utileria;
 

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cliente.bean.CobroReactivaCliBean;
import general.dao.BaseDAO;

public class CobroReactivaCliDAO extends BaseDAO {

	public CobroReactivaCliDAO() {
		super();
	}

	private final static String salidaPantalla = "S";
	
	// ------------------ Transacciones ------------------------------------------

	//Consulta de Clientes PROFUN
		public CobroReactivaCliBean consultaCobroReactivaCli(final CobroReactivaCliBean cobroReactivaCli, int tipoConsulta){
			CobroReactivaCliBean cobroReactivaCliBean = null;
			try{
				String query = "call COBROREACTIVACLICON(" +
					"?,?,?,?,?, ?,?,?,?);"; 
					
				Object[] parametros = {
						Utileria.convierteEntero(cobroReactivaCli.getNumero()),
						tipoConsulta,						
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"CobroReactivaCliDAO.consultaCobroReactivaCli",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
					};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COBROREACTIVACLICON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						CobroReactivaCliBean cobroReactivaCliBean = new CobroReactivaCliBean();
						cobroReactivaCli.setEstatus(resultSet.getString("Estatus"));
						return cobroReactivaCli;
					}
				});
				cobroReactivaCliBean  = matches.size() > 0 ? (CobroReactivaCliBean) matches.get(0) : null;
				
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de Cobros reactivacion cliente", e);
			}
			return cobroReactivaCliBean;
		}
					
}

