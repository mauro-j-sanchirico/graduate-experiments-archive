function ChangeDirAndGenerateAllTables()

design_flags = GetDesignFlags();

if design_flags.new_q_table
    fprintf('Building a new "Q Table"...\n');
    ChangeDirAndGenerateQTable();
end

if design_flags.new_mu_table
    fprintf('Building a new "Mu Table"...\n');
    ChangeDirAndGenerateMuTable();
end

if design_flags.new_lambda_table
    fprintf('Building a new "Lambda Table"...\n');
    ChangeDirAndGenerateLambdaTable();
end

end

