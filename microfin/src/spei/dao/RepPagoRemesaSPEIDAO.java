	package spei.dao;
	
	import org.springframework.dao.DataAccessException;
	import org.springframework.jdbc.core.CallableStatementCallback;
	import org.springframework.jdbc.core.CallableStatementCreator;
	import org.springframework.jdbc.core.JdbcTemplate;

	import general.bean.MensajeTransaccionBean;
	import general.dao.BaseDAO;
	import herramientas.Constantes;

	import java.sql.CallableStatement;
	import java.sql.Connection;
	import java.sql.ResultSet;
	import java.sql.SQLException;
	import java.sql.Types;
	import java.util.Arrays;
	import java.util.List;

	import org.springframework.jdbc.core.RowMapper;
	import org.springframework.transaction.TransactionStatus;
	import org.springframework.transaction.support.TransactionCallback;
	import org.springframework.transaction.support.TransactionTemplate;

	import spei.bean.RepPagoRemesaSPEIBean;



		public class RepPagoRemesaSPEIDAO extends BaseDAO  {
		
			
			public RepPagoRemesaSPEIDAO() {
				super();
			}
			

			
		}





